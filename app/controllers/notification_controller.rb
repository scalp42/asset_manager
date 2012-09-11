class NotificationController < ApplicationController
  layout 'admin'
  include NotificationHelper

  def index
    @notifications = NotificationScheme.all

    setSidebar(nil,nil,nil,nil,true)
  end

  def create
      notificationScheme = NotificationScheme.new(:name => params[:name][:name],:description => params[:description][:description],:asset_type_id => BSON::ObjectId.from_string(params[:asset_type][:asset_type]),
                                    :create_email => {'users' => {},'groups' => {}},
                                    :edit_email => {'users' => {},'groups' => {}},
                                    :delete_email => {'users' => {},'groups' => {}})

      if notificationScheme.save
        @notifications = NotificationScheme.all
        notificationReturn(notificationScheme.name,"Created")
        render :template => "notification/index"
      end
    end

    def view_notifications
      @notification = NotificationScheme.find(params[:id])
      setSidebar(nil,nil,nil,nil,true)
    end

    def add_remove_users

      @notification =  NotificationScheme.find(BSON::ObjectId.from_string(params[:notification_id][:notification_id]))

      users = Array.new
      users.push(params[:users][:users])

      case params[:notification_type][:notification_type]
        when 'create'
          @notification.create_email['users'] = users
        when 'edit'
          @notification.edit_email['users'] = users
        when 'delete'
          @notification.delete_email['users'] = users
      end

      if @notification.save
        notificationReturn(@notification.name,"Updated")
        setSidebar(nil,nil,nil,nil,true)
        render :template => 'notification/view_notifications'
      end

    end

    def add_remove_groups

      @notification =  NotificationScheme.find(BSON::ObjectId.from_string(params[:notification_id][:notification_id]))

      groups = Array.new
      groups.push(params[:groups][:groups])

      case params[:notification_type][:notification_type]
        when 'create'
          @notification.create_email['groups'] = groups
        when 'edit'
          @notification.edit_email['groups'] = groups
        when 'delete'
          @notification.delete_email['groups'] = groups
      end

      if @notification.save
        notificationReturn(@notification.name,"Updated")
        setSidebar(nil,nil,nil,nil,true)
        render :template => 'notification/view_notifications'
      end
    end

    def delete
      if NotificationScheme.destroy(BSON::ObjectId.from_string(params['notification_id']))
        notificationReturn('',"Deleted")
        setSidebar(nil,nil,nil,nil,true)
        @notifications = NotificationScheme.all

        render :template => "notification/index"
      end

    end
end
