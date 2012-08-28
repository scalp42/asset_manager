class SearchController < ApplicationController
  include SearchHelper

  def index

    @filters = Filter.all
  end

  def search

    @searchCriteria = SearchCriteria.new

    assetTypesArr = Array.new

    if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
      params[:asset_type][:asset_type_id].each do |asset_type_id|
        if(asset_type_id != '')
          assetTypesArr.push(asset_type_id)
        end
      end
      @searchCriteria.asset_types = assetTypesArr
    end

    if params[:name][:name] != ''
      @searchCriteria.name = (params[:name][:name])
    end

    if params[:description][:description] != ''
      @searchCriteria.description = (params[:description][:description])
    end

    fields = Hash.new

    Field.all.each do |field|
      if params[field.name] != nil
        fields[field.id] = params[field.name][field.name]
      end
    end

    @searchCriteria.fields = fields

    #createFilter(params,fields)

    search_elastic(@searchCriteria)

    @filters = Filter.all

    @showCreateFilter = true

  end

  def load_filter
    buildSearchCriteria(params[:filter_id])

    results = Sunspot.search [Asset] do
      #if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
      #   with(:asset_type_id,params[:asset_type][:asset_type_id]  )
      #end
    end

    @assets = results.results

    @filters = Filter.all

    @showCreateFilter = true

    render :template => 'search/search'

  end

end
