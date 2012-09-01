class Api::AssetTypeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index

  end

end
