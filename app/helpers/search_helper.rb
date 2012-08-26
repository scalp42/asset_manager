module SearchHelper

  def createFilter(params,fields)

    if params[:filter_value] != nil
      filter = Filter.new(:available => true,:name => params[:filter_value])
      filter.save

      if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
        params[:asset_type][:asset_type_id].each do |asset_type|
          if asset_type != ''
            filterDetails = FilterDetails.new(:asset_type_id => asset_type,:filter_id=> filter.id )
            filterDetails.save
          end
        end
      end

      if params[:name][:name] != ''
        filterDetails = FilterDetails.new(:name => params[:name][:name],:filter_id=> filter.id )
        filterDetails.save
      end

      if params[:description][:description] != ''
        filterDetails = FilterDetails.new(:description => params[:description][:description],:filter_id=> filter.id )
        filterDetails.save
      end

      fields.each do |key, value|
        field = Field.find(key)
        if(FieldType.find(field.field_type_id)).use_option?
          value.each do |option|
            if option != ''
              filterDetails = FilterDetails.new(:field_option_id => option,:field_id => key,:filter_id=> filter.id )
              filterDetails.save
            end
          end
        elsif (FieldType.find(field.field_type_id)).use_date?
          filterDetails = FilterDetails.new(:date_search => value,:field_id => key,:filter_id=> filter.id )
          filterDetails.save
        elsif (FieldType.find(field.field_type_id)).use_text?
          filterDetails = FilterDetails.new(:text_search => value,:field_id => key,:filter_id=> filter.id )
          filterDetails.save
        end
      end
    end

  end

  def buildSearchCriteria(filter_id)

    filter = Filter.find(filter_id)
    @searchCriteria = SearchCriteria.new

    filterDetails = FilterDetails.all(:conditions["asset_type_id is ? and filter_id= ?"], nil,filter.id)

    if(filterDetails != nil)
      asset_types = Array.new
      filterDetails.each do |filterDetail|
        asset_types.push(filterDetail.asset_type_id)
      end
      @searchCriteria.asset_types = asset_types
    end


    filterDetails = FilterDetails.first(:conditions["name is ? and filter_id= ?"], nil,filter.id)
    if filterDetails != nil
      @searchCriteria.name = filterDetails.name
    end

    filterDetails = FilterDetails.first(:conditions["description is ? and filter_id=?"],nil,filter.id)
    if filterDetails.name != nil
      @searchCriteria.description = filterDetails.description
    end

    fields = Hash.new

    filterDetails = FilterDetails.all(:conditions["field_id is not ? and filter_id= ? "],nil, filter.id)

    filterDetails.each do |filterDetail|
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

    @searchCriteria.fields = fields

  end

  def search_solr(searchCriteria)

    fields = searchCriteria.fields

    #
    #results = Sunspot.search [Asset]do
    #
    #  if(searchCriteria.asset_types != nil && searchCriteria.asset_types.count > 0)
    #    fulltext searchCriteria.asset_types do
    #      fields('asset_type_id')
    #    end
    #  end
    #
    #  if searchCriteria.name != nil
    #    fulltext searchCriteria.name do
    #      fields('name')
    #    end
    #  end
    #
    #  if searchCriteria.description != nil
    #    fulltext searchCriteria.description do
    #      fields('description')
    #    end
    #  end
    #
    #  Field.all.each do |field|
    #    if fields[field.id] != nil
    #      if FieldType.find(BSON::ObjectId.from_string(field.field_type_id)).use_option
    #        fulltext fields[field.id] do
    #          fields(:field_value)
    #        end
    #      elsif FieldType.find(BSON::ObjectId.from_string(field.field_type_id)).use_text
    #        fulltext fields[field.id] do
    #          fields(:field_value)
    #        end
    #      end
    #    end
    #  end
    #
    #end
    #
    #@assets = results.results
  end
end
