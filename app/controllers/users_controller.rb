class UsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.all
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

    redirect_to :back
  end

  def create

  end
end
