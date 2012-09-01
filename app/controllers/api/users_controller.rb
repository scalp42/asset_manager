class Api::UsersController < Api::BaseController
  before_filter :authenticate_user!
  before_filter :ensure_params_exist, :except => [:index]
  before_filter :ensure_email_params_exist, :except => [:index]
  respond_to :json

  def index
    render :json =>{ :users => User.all }
  end

  def create

  end

  protected
  def ensure_params_exist
    return unless params[:user].blank?
    render :json=>{:success=>false, :message=>"missing user parameter"}
  end

  protected
  def ensure_email_params_exist
    return unless params[:user][:email].blank?
    render :json=>{:success=>false, :message=>"missing email parameter"}
  end

  protected
  def ensure_password_params_exist
    return unless params[:user][:password].blank?
    render :json => {:success => false, :message => "missing password parameter"}
  end
end
