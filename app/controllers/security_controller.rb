class SecurityController < ApplicationController
  layout 'admin'
  include SecurityHelper

  def index
    @securities = SecurityScheme.all

    setSidebar(nil,nil,nil,nil,nil,nil,true)
  end

  def create
    security = SecurityScheme.new(:name => params[:name][:name],:description => params[:description][:description])

    if security.save
      @securities = SecurityScheme.all
      securityReturn(security.name,"Created")
      render :template => "security/index"
    end
  end
end
