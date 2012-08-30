module SearchHelper

  def createFilter(params,fields)

    if params[:filter_value] != nil
      filter = Filter.new(:available => true,:name => params[:filter_value])

      if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
        params[:asset_type][:asset_type_id].each do |asset_type|
          if asset_type != ''
            filter.filter_detail.build(:asset_type_id => asset_type,:filter_id=> filter.id )
          end
        end
      end

      if params[:name][:name] != ''
        filter.filter_detail.build(:name => params[:name][:name],:filter_id=> filter.id )
      end

      if params[:description][:description] != ''
        filter.filter_detail.build(:description => params[:description][:description],:filter_id=> filter.id )
      end

      fields.each do |key, value|
        field = Field.find(key)
        if(FieldType.find(field.field_type_id)).use_option?
          value.each do |option|
            if option != ''
              filter.filter_detail.build(:field_option_id => option,:field_id => key,:filter_id=> filter.id )
            end
          end
        elsif (FieldType.find(field.field_type_id)).use_date?
          filter.filter_details.build(:date_search => value,:field_id => key,:filter_id=> filter.id )
        elsif (FieldType.find(field.field_type_id)).use_text?
          filter.filter_detail.build(:text_search => value,:field_id => key,:filter_id=> filter.id )
        end
      end

      filter.save
    end

  end

  def buildSearchCriteria(filter_id)

    filter = Filter.find(filter_id)
    @searchCriteria = SearchCriteria.new

    asset_types = Array.new
    fields = Hash.new
    filter.filter_detail.each do |filterDetail|
      if filterDetail.asset_type_id != nil
        asset_types.push(filterDetail.asset_type_id)
      end

      if filterDetail.name != nil
        @searchCriteria.name = filterDetails.name
      end

      if filterDetail.description != nil
        @searchCriteria.description = filterDetails.description
      end

      if filterDetail.field_id != nil and FieldType.find(Field.find(filterDetail.field_id).field_type_id).use_option?
        if fields.has_key?(filterDetail.field_id)
          options = fields[filterDetail.field_id]
          options.push(filterDetail.field_option_id)
          fields[filterDetail.field_id] = options
        else
          options = Array.new
          options.push(filterDetail.field_option_id)
          fields[filterDetail.field_id] = options
        end
      elsif filterDetail.field_id != nil and FieldType.find(Field.find(filterDetail.field_id).field_type_id).use_text?
        fields[filterDetail.field_id] = filterDetail.text_search
      elsif filterDetail.field_id != nil and FieldType.find(Field.find(filterDetail.field_id).field_type_id).use_date?
        fields[filterDetail.field_id] = filterDetail.date_search
      end

    end
    @searchCriteria.asset_types = asset_types
    @searchCriteria.fields = fields

  end

  def search_elastic(searchCriteria)

    results = Tire.search 'assets' do
      query do
        if searchCriteria.name != nil
          string 'name:'+searchCriteria.name
        end
        if searchCriteria.description != nil
          string 'description:'+searchCriteria.description
        end
        boolean do
          if searchCriteria.asset_types != nil
            must do
              boolean do
                searchCriteria.asset_types.each do |asset_type|
                  if asset_type != ''
                    should { string 'asset_type_id:'+asset_type }
                  end
                end
              end
            end
          end
          searchCriteria.fields.each_pair do |k,v|
            if FieldType.find(Field.find(BSON::ObjectId.from_string(k.to_s)).field_type_id).use_option
              if v.size > 1 and v[1] != ''
                must do
                  boolean do
                    v.each do |value|
                      if value != '' and !value.empty?
                        should { string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+value }
                      end
                    end
                  end
                end
              end
            elsif  FieldType.find(Field.find(BSON::ObjectId.from_string(k.to_s)).field_type_id).use_casecade_option
              if v['parent'] != ''
                must do
                  boolean do
                    should { string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+'_parent:'+v['parent'] }
                    if v['child']
                      should { string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+'_child:'+v['child'] }
                    end
                  end
                end
              end
            end
          end
        end
        searchCriteria.fields.each_pair do |k,v|
          if FieldType.find(Field.find(k).field_type_id).use_text
            if v != nil and v != ''
              string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+v
            end
            #elsif FieldType.find(Field.find(k).field_type_id).use_date
            #  date 'field_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+v
          elsif FieldType.find(Field.find(k).field_type_id).use_radio_option
            string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+v
          end
        end
      end
    end

    @assets = results.results

  end
end
