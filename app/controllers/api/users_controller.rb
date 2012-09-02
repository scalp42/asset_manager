class Api::UsersController < Api::BaseController
  before_filter :authenticate_user!
  before_filter :ensure_params_exist, :except => [:index]
  before_filter :ensure_email_params_exist, :except => [:index]
  before_filter :ensure_password_params_exist, :except => [:index]
  respond_to :json

  def index
    render :json =>{ :users => User.all }
  end

  def create

    user = User.new(:email => params[:user][:email],:password => params[:user][:password],:password_confirmation => params[:user][:password],:active => true)

    if params[:user][:first_name] != nil
      user.first_name = params[:user][:first_name]
    end

    if params[:user][:last_name] != nil
      user.last_name = params[:user][:last_name]
    end

    if user.first_name != nil and user.last_name != nil
      user.full_name = user.first_name+" "+user.last_name
    end

    if user.save
      render :json => {:success => true, :id => user.id}
    end

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
