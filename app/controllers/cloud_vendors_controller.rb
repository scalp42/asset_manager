class CloudVendorsController < ApplicationController
  layout 'admin'
  include CloudVendorsHelper

  def index
    setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)
    @cloudVendors = CloudVendor.all
  end

  def create

  end

  def edit

  end

  def test_connection

  end
end
