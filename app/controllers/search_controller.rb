class SearchController < ApplicationController
  include SearchHelper

  def index

    @filters = Filter.find_all_by_available(true)
  end

  def search

    @searchCriteria = SearchCriteria.new

    if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
      @searchCriteria.asset_types = params[:asset_type][:asset_type_id]
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

    createFilter(params,fields)

    search_solr(@searchCriteria)

    @filters = Filter.find_all_by_available(true)

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

    @filters = Filter.find_all_by_available(true)

    @showCreateFilter = true

    render :template => 'search/search'

  end

end
