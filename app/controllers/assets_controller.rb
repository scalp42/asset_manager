class AssetsController < ApplicationController
  include AssetsHelper
  include EncryptDecryptPasswordHelper

  respond_to :html, :xml, :json

  def index
    @assets = Asset.all

    respond_with(@assets) do |format|
      format.html
      format.json { render :json => @assets }
    end
  end

  def create
    @asset_type = AssetType.find(BSON::ObjectId.from_string(params[:id]))
  end

  def save

    asset = Asset.new(:name => params[:name][:name],:description => params[:description][:description])

    asset_type = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))

    asset.asset_type_id = asset_type.id
    asset.asset_type_name = asset_type.name

    asset_type.asset_screen.each do |field|
      fieldObj = Field.find(field.field_id)
      if params[fieldObj.name][fieldObj.name] != nil and params[fieldObj.name][fieldObj.name] != ''
        setFieldValue(params,fieldObj,asset)
      elsif params[fieldObj.name.gsub(" ","_")+"_parent"] != nil and params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"] != nil
        setCascadeValue(params,fieldObj,asset)
      end
    end

    asset.created_at = DateTime.now

    asset.created_by = current_user.id

    asset.save

    assetAlert(asset.name,"Created")

    sendNotificationEmailsViaScheme(asset,'create')
    @assets = Asset.all

    render :template => 'assets/index'
  end

  def delete
    asset = Asset.find(params[:asset_id])

    Asset.destroy(params[:asset_id])

    ChangeHistory.pull_all(:asset_id => asset.id)

    assetAlert(asset.name,"Deleted")

    sendNotificationEmailsViaScheme(asset,'delete')
    @assets = Asset.all

    render :template => 'assets/index'
  end

  def edit
    @asset = Asset.find(params[:id])

  end

  def update

    asset = Asset.find(params[:asset][:asset_id])

    changeHistory = ChangeHistory.new(:asset_id => asset.id,:asset_type_id => asset.asset_type_id,:changed_by => current_user.id)

    if asset.name != params[:name][:name]
      changeHistory.change_history_detail.build(:string_previous_value => asset.name,:string_new_value => params[:name][:name])
    end
    asset.name = params[:name][:name]

    if params[:description][:description] != nil
      asset.description = params[:description][:description]
    else
      asset.description = nil
    end

    if asset.description != params[:description][:description]
      changeHistory.change_history_detail.build(:string_previous_value => asset.description,:string_new_value => params[:description][:description])
    end

    fieldsToDelete = Array.new

    AssetType.find(asset.asset_type_id).asset_screen.each do |field|
      fieldObj = Field.find(field.field_id)
      createField = true
      if params[fieldObj.name][fieldObj.name] != nil and params[fieldObj.name][fieldObj.name]  != ''
        asset.field_value.each do |fieldValue|
          if fieldObj.id == fieldValue.field_id
            createField = false
            updateFieldValue(params,fieldObj,fieldValue,asset)
          end
        end
        if createField
          setFieldValue(params,fieldObj,asset)
        end
      elsif params[fieldObj.name.gsub(" ","_")+"_parent"] != nil and params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"] != ""
        updateCascadeValue(params,fieldObj,asset)
      elsif params[fieldObj.name.gsub(" ","_")+"_parent"] != nil and params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"] == "" and  asset.field_value.detect {|c|c.field_id == fieldObj.id} != nil
        fieldsToDelete.push(fieldObj.id)
      elsif params[fieldObj.name][fieldObj.name]  == '' and  asset.field_value.detect {|c|c.field_id == fieldObj.id} != nil
        fieldsToDelete.push(fieldObj.id)
      end
    end

    changeHistory.changed_at = DateTime.now
    changeHistory.save

    asset.save

    sendNotificationEmailsViaScheme(asset,'edit')

    deleteFields(fieldsToDelete,asset)

    assetAlert(asset.name,"Updated")

    @assets = Asset.all

    render :template => 'assets/index'
  end

  def view
    @asset = Asset.find(params[:id])
    respond_with(@asset) do |format|
      format.html
      format.json { render :json => @asset }
    end
  end

  def getChildOptions()

    field = Field.find(BSON::ObjectId.from_string(params['field_id']))

    @childOptions = Array.new
    field.field_option.each do |field_option|
      if field_option.parent_field_option == BSON::ObjectId.from_string(params['data'])
        @childOptions.push(field_option)
      end
    end

    respond_to do |format|
      format.json { render :json => @childOptions }
    end

  end

  def api_decryptPassword
    @password = decryptPassword(params['data'])
    respond_to do |format|
      format.json { render :json => @password }
    end

  end

  def pull_all_vendor_assets
    cloud_vendor = CloudVendor.find(params[:vendor_creds])

    if CloudVendorType.find(cloud_vendor.cloud_vendor_type).vendor_name == "Rackspace Cloud"
      begin
        cs = CloudServers::Connection.new(:username => cloud_vendor.username, :api_key => cloud_vendor.api_key)
        cs.servers.each do |server|
          if Asset.where(:asset_vendor_id => server[:id]).count == 0
            asset = Asset.create(:name => server[:name],:asset_type_id =>params[:asset_type_id],:asset_vendor_id => server[:id],:created_by => current_user.id ,:created_at => DateTime.now )
            serverDetails = cs.server(server[:id])

            Field.where(:vendor_type => cloud_vendor.cloud_vendor_type).each do |field|

              case field.name
                when 'RS Public IP'
                  asset.field_value.build(:asset_id => asset.id,
                                          :text_value => serverDetails.addresses[:public][0],
                                          :field_name_value => {field.name.downcase.gsub(" ","_") => serverDetails.addresses[:public] } ,
                                          :field_id => field.id)
                when 'RS Private IP'
                  asset.field_value.build(:asset_id => asset.id,
                                          :text_value => serverDetails.addresses[:private][0],
                                          :field_name_value => {field.name.downcase.gsub(" ","_") => serverDetails.addresses[:private] } ,
                                          :field_id => field.id)
                when 'RS Flavor'
                  option = field.field_option.detect {|c|c.option == cs.get_flavor(serverDetails.flavorId).name}
                  asset.field_value.build(:asset_id => asset.id,
                                          :field_option_id => option.id,
                                          :field_id => field.id,
                                          :field_name_value => {field.name.downcase.gsub(" ","_") =>option.id} ,
                                          :text_value =>option.option)
                when 'RS Operating System'
                  option = field.field_option.detect {|c|c.option == cs.get_image(serverDetails.imageId).name}
                  asset.field_value.build(:asset_id => asset.id,
                                          :field_option_id => option.id,
                                          :field_id => field.id,
                                          :field_name_value => {field.name.downcase.gsub(" ","_") =>option.id} ,
                                          :text_value =>option.option)
              end
            end

            asset.save
          else
            asset = Asset.first(:asset_vendor_id => server[:id])
            asset.name = server[:name]

            serverDetails = cs.server(server[:id])

            Field.where(:vendor_type => cloud_vendor.cloud_vendor_type).each do |field|

              case field.name
                when 'RS Public IP'
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.text_value = serverDetails.addresses[:public][0] }
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.field_name_value = {field.name.downcase.gsub(" ","_") => serverDetails.addresses[:public][0] } }
                when 'RS Private IP'
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.text_value = serverDetails.addresses[:private][0] }
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.field_name_value = {field.name.downcase.gsub(" ","_") => serverDetails.addresses[:private][0] } }
                when 'RS Flavor'
                  option = field.field_option.detect {|c|c.option == cs.get_flavor(serverDetails.flavorId).name}
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b|  b.field_option_id = option.id}
                  asset.field_value.select {|b| b.field_id == field.id}.each {|b| b.text_value = option.option}
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.field_name_value = {field.name.downcase.gsub(" ","_") => option.id } }
                when 'RS Operating System'
                  option = field.field_option.detect {|c|c.option == cs.get_image(serverDetails.imageId).name}
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b|  b.field_option_id = option.id}
                  asset.field_value.select {|b| b.field_id == field.id}.each {|b| b.text_value = option.option}
                  asset.field_value.select { |b| b.field_id == field.id }.each { |b| b.field_name_value = {field.name.downcase.gsub(" ","_") => option.id } }
              end
            end

            asset.save
          end
        end

      rescue

      end

    end

    redirect_to :controller => 'admin_field', :action => 'list_asset_types'
  end

end
