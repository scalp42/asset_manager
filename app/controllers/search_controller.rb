class SearchController < ApplicationController

  def index

  end

  def search

    puts params.inspect

    results = Sunspot.search [Asset,FieldOption,FieldValue,AssetType] do
      fulltext params[:name][:name]
      fulltext params[:description][:description]
    end

    @assets = results.results

  end

end
