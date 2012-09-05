class GroupController < ApplicationController
  layout 'admin'
  include GroupHelper

   def index
     @groups = Group.all
     setSidebar(nil,nil,nil,nil,nil,true)
   end

   def edit_group
     group = Group.find(params['group']['group_id'])

     #
     #user.first_name = params['first_name']['first_name']
     #user.last_name = params['last_name']['last_name']
     #user.full_name = params['first_name']['first_name']+' '+params['last_name']['last_name']
     #
     #user.save
     #
     #setSidebar(nil,nil,nil,nil,nil,true)
     #redirect_to :back
   end

   def create

     group = Group.new(:name =>params['name']['name'],:description => params['description']['description'])

     if group.save
       groupReturn(group.name,"Created")
       @groups = Group.all
       render :template => 'group/index'
     end

   end
end
