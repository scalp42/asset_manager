class IndexController < ApplicationController
  layout 'admin'

  def index

  end

  def reindex
    Tire.index('assets').delete

    Asset.import :per_page => 1000

    @indexAlert = true

    render :template => "index/index"
  end

end
