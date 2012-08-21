class SearchController < ApplicationController
  include SearchHelper

  def index

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
    results = Sunspot.search [Asset] do
      #if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
      #   with(:asset_type_id,params[:asset_type][:asset_type_id]  )
      #end
    end

    @assets = results.results

    @filters = Filter.find_all_by_available(true)

    @showCreateFilter = true

  end

end
