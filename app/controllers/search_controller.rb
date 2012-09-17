class SearchController < ApplicationController
  include SearchHelper

  def index
    @filters = Filter.where(:user_id => current_user.id)
  end

  def search

    searchCriteria = SearchCriteria.new

    assetTypesArr = Array.new

    if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
      params[:asset_type][:asset_type_id].each do |asset_type_id|
        if asset_type_id != ''
          assetTypesArr.push(asset_type_id)
        end
      end
      searchCriteria.asset_types = assetTypesArr
    end

    if params[:name][:name] != ''
      searchCriteria.name = (params[:name][:name])
    end

    if params[:description][:description] != ''
      searchCriteria.description = (params[:description][:description])
    end

    fields = Hash.new

    Field.all.each do |field|
      if params[field.name] != nil
        if FieldType.find(field.field_type_id).use_casecade_option
          cascadingValues = Hash.new
          cascadingValues['parent'] = params[field.name.gsub(" ","_")+"_parent"][field.name.gsub(" ","_")+"_parent"]
          cascadingValues['child'] = params[field.name.gsub(" ","_")+"_child"][field.name.gsub(" ","_")+"_child"]
          fields[field.id] = cascadingValues
        else
          fields[field.id] = params[field.name][field.name]
        end

      end
    end

    searchCriteria.fields = fields

    @searchJson = searchCriteria.to_json

    search_elastic(@searchJson)

    @filters = Filter.where(:user_id => current_user.id)

    @showCreateFilter = true

  end

  def paginate

    object =  params[:search]

    @searchJson = object.gsub("&quot;","\"")
    search_elastic(@searchJson,Integer(params[:page]))


    @filters = Filter.where(:user_id => current_user.id)

    @showCreateFilter = true

    render :template => 'search/search'
  end

  def create_filter

    searchObj =  params[:search][:search_json]

    @searchJson = searchObj.gsub("&quot;","\"")

    createFilter(params,@searchJson)

    search_elastic(@searchJson)

    @filters = Filter.where(:user_id => current_user.id)

    @showCreateFilter = true

    render :template => 'search/search'
  end

  def load_filter
    buildSearchCriteria(params[:filter_id])

    search_elastic(@searchJson)

    @filters = Filter.where(:user_id => current_user.id)

    @showCreateFilter = true

    render :template => 'search/search'

  end

  def delete_filter
    @filters = Filter.where(:user_id => current_user.id)

    if Filter.delete(BSON::ObjectId.from_string(params['filter_id']))
    end

    render :template => 'search/index'
  end

end
