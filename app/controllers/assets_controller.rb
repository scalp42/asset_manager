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

    @assets = Asset.all

    render :template => 'assets/index'
  end

  def delete
    asset = Asset.find(params[:asset_id])

    Asset.destroy(params[:asset_id])

    ChangeHistory.pull_all(:asset_id => asset.id)

    assetAlert(asset.name,"Deleted")

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

end
