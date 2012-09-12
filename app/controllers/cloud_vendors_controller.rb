class CloudVendorsController < ApplicationController
  layout 'admin'
  include CloudVendorsHelper

  def index
    setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)
    @cloudVendors = CloudVendor.all
  end

  def create

    cloudVendor = CloudVendor.new(:name => params[:name][:name],:description => params[:description][:description])

    if params[:rackspace][:username].present?
      cloudVendorType = CloudVendorType.first(:vendor_name => 'Rackspace Cloud')
      cloudVendor.cloud_vendor_type = cloudVendorType.id
      cloudVendor.username = params[:rackspace][:username]
      cloudVendor.api_key = params[:rackspace][:api_key]
    elsif params[:vendor][:vendor].eql? 'amazon'

    end

    if cloudVendor.save
      setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)
      vendorAlert(cloudVendor.name,"Created")
      @cloudVendors = CloudVendor.all
      render :template => 'cloud_vendors/index'
    end
  end

  def edit

  end

  def test_connection
     CloudVendor.find(params[:cloud_vendor_id])
  end

  def delete

    CloudVendor.destroy(params[:cloud_vendor_id])
    setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)
    vendorAlert('',"Deleted")
    @cloudVendors = CloudVendor.all
     render :template => 'cloud_vendors/index'
  end
end
