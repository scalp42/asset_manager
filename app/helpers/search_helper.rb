module SearchHelper

  def createFilter(params,search_criteria_json)

    if params[:filter_value] != nil and params[:filter_value] != ''
      filter = Filter.new(:available => true,:name => params[:filter_value],:user_id => current_user.id)
      filter.search_criteria = search_criteria_json
      filter.save
    end


  end

  def buildSearchCriteria(filter_id)

    filter = Filter.find(filter_id)
    @searchJson = filter.search_criteria

  end

  def search_elastic(searchCriteriaJson, page = 0)

    searchCriteria = JSON.parse(searchCriteriaJson)

    from = 0

    if page > 0
      from = 25 * page
    end

    query = Tire.search('assets',{:page => page , :per_page=>25, :size=>25, :from=>from})  do
      query do
        boolean do
          if searchCriteria['name'] != nil
            must do
              boolean do
                should { string 'name~'+searchCriteria['name']+'*'    }
              end
            end
          end
          if searchCriteria['description'] != nil
            must do
              boolean do
                should {string 'description~'+searchCriteria['description']+'*'  }
              end
            end
          end
          if searchCriteria['asset_types'] != nil
            must do
              boolean do
                searchCriteria['asset_types'].each do |asset_type|
                  if asset_type != ''
                    should { string 'asset_type_id:'+asset_type }
                  end
                end
              end
            end
          end
          searchCriteria['fields'].each_pair do |k,v|
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
        searchCriteria['fields'].each_pair do |k,v|
          if FieldType.find(Field.find(k).field_type_id).use_text
            if v != nil and v != ''
              string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+'~'+v+'*'
            end
            #elsif FieldType.find(Field.find(k).field_type_id).use_date
            #  date 'field_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+v
            #elsif FieldType.find(Field.find(k).field_type_id).use_radio_option
            #  string 'field_value.field_name_value.'+Field.find(k).name.downcase.gsub(" ","_")+':'+v
          end
        end
      end
    end

    @assets = query.results

  end

  def accessibleAssetTypes
    assetTypes = Array.new

    AssetType.all.each do |assetType|
      if can_view(assetType.id.to_s)
        assetTypes.push(assetType)
      end
    end

    return assetTypes
  end

end
