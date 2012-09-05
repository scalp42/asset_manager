class Api::AssetTypeController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_params_exist, :except => [:index]
  respond_to :json

  def index

    assetTypes = AssetType.all

    render :json =>{ :asset_types => assetTypes }
  end

  protected
  def ensure_params_exist
    return unless params[:asset].blank?
    render :json=>{:success=>false, :message=>"missing asset parameter"}
  end
end
