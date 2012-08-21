class SearchController < ApplicationController

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

    results = Sunspot.search [Asset] do

    end

    @assets = results.results

  end

  def create_filter

    puts "KJSDLKFJSLKDJF"
    puts params.inspect
  end

end
