class NotificationController < ApplicationController
  layout 'admin'
  include NotificationHelper

  def index
    setSidebar(nil,nil,nil,nil,true)
  end
end
