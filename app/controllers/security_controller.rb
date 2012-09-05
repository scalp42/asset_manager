class SecurityController < ApplicationController
  layout 'admin'
  include SecurityHelper

  def index
    @securities = SecurityScheme.all

    setSidebar(nil,nil,nil,nil,nil,nil,true)
  end
end
