class UsersController < ApplicationController
  layout 'admin'
  include AdminFieldHelper

  def index
    @users = User.all
    setSidebar(nil,nil,true,nil)
  end

  def edit_user
    user = User.find(params['user']['user_id'])

    if params['active'] == "yes"
      user.active = true
    else
      user.active = false
    end

    user.first_name = params['first_name']['first_name']
    user.last_name = params['last_name']['last_name']
    user.full_name = params['first_name']['first_name']+' '+params['last_name']['last_name']

    user.save

    setSidebar(nil,nil,true,nil)
    redirect_to :back
  end

  def create

    user = User.new()

    user.first_name = params['first_name']['first_name']
    user.last_name = params['last_name']['last_name']
    user.full_name = params['first_name']['first_name']+' '+params['last_name']['last_name']
    user.email = params['email']['email']
    user.password = params['password']['password']
    user.password_confirmation = params['password_confirmation']['password_confirmation']

    user.active = true

    if user.save
      setSidebar(nil,nil,true,nil)
      redirect_to :back
    end

  end
end
