class CloudVendorsController < ApplicationController
  layout 'admin'
  include CloudVendorsHelper
  include AssetsHelper

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
    elsif params[:amazon][:access_id].present?
      cloudVendorType = CloudVendorType.first(:vendor_name => 'Amazon EC2 Cloud')
      cloudVendor.cloud_vendor_type = cloudVendorType.id
      cloudVendor.username = params[:amazon][:access_id]
      cloudVendor.api_key = params[:amazon][:secret_access_key]
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
    cloudVendor = CloudVendor.find(params[:id])

    if CloudVendorType.find(cloudVendor.cloud_vendor_type).vendor_name == "Rackspace Cloud"
      begin
        cs = CloudServers::Connection.new(:username => cloudVendor.username, :api_key => cloudVendor.api_key)
        vendorAlert(cloudVendor.name,"Connected")
      rescue
        vendorErrorAlert(cloudVendor.name,"Could Not Connect")
      end
    elsif CloudVendorType.find(cloudVendor.cloud_vendor_type).vendor_name == "Amazon EC2 Cloud"
      begin
        AWS.config(:access_key_id => cloudVendor.aws_access_key_id,
                    :secret_access_key => cloudVendor.aws_secret_access_key)

        ec2 = AWS::EC2.new(
            :access_key_id => cloudVendor.aws_access_key_id,
            :secret_access_key => cloudVendor.aws_secret_access_key)


        ec2.images.with_owner("amazon").map(&:name).each do |image|
          puts image.inspect
        end
        puts 'ksdjfksjdlfjsdklfjlksdjfkl'
        vendorAlert(cloudVendor.name,"Connected")
      rescue Exception => e
        puts e.message
        puts 'ksdjfklsdfdssdjflkjdskfjlsdjf'
        vendorErrorAlert(cloudVendor.name,"Could Not Connect")
      end
    end

    setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)

    @cloudVendors = CloudVendor.all
    render :template => 'cloud_vendors/index'
  end

  def delete

    CloudVendor.destroy(params[:cloud_vendor_id])
    setSidebar(nil,nil,nil,nil,nil,nil,nil,nil,true)
    vendorAlert('',"Deleted")
    @cloudVendors = CloudVendor.all
    render :template => 'cloud_vendors/index'
  end

  def delete_server
    asset = Asset.find(params[:asset_id])

    delete_server_vendor(asset)

    delete_asset(asset)

    @assets = Asset.all

    render :template => 'assets/index' ,:layout => 'assets'
  end

  def create_server
    @asset = Asset.find(params[:id])

    create_server_vendor(@asset)
    render :template => 'assets/view' ,:layout => 'assets'
  end

  def resize_server
    @asset = Asset.find(params[:id])

    resize_server_vendor(@asset)
    render :template => 'assets/view' ,:layout => 'assets'
  end

  def server_status
    status = get_current_status(params[:cloud_vendor_id],params[:server_id])

    respond_to do |format|
      format.json { render :json => status }
    end
  end
end
