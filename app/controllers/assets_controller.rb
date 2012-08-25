class AssetsController < ApplicationController
  include AssetsHelper

  def index
    @assets = Asset.all

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
      if params[fieldObj.name][fieldObj.name] != nil
        setFieldValue(params,fieldObj,asset)
      end
    end

    asset.save

    redirect_to :action => 'index'
  end

  def delete
    Asset.destroy(params[:asset_id])

    redirect_to :back
  end

  def edit
    @asset = Asset.find(params[:id])

  end

  def update

    asset = Asset.find(params[:asset][:asset_id])

    if(params[:name][:name] != nil)
      asset.name = params[:name][:name]
    else
      asset.name = nil
    end

    if(params[:description][:description] != nil)
      asset.description = params[:description][:description]
    else
      asset.description = nil
    end

    fieldsToDelete = Array.new

    AssetType.find(asset.asset_type_id).asset_screen.each do |field|
      fieldObj = Field.find(field.field_id)
      createField = true
      if params[fieldObj.name][fieldObj.name] != nil and params[fieldObj.name][fieldObj.name]  != ''
        asset.field_value.each do |fieldValue|
          if(fieldObj.id == fieldValue.field_id)
            createField = false
            updateFieldValue(params,fieldObj,fieldValue,asset)
          end
        end
        if createField
          setFieldValue(params,fieldObj,asset)
        end
      elsif params[fieldObj.name][fieldObj.name]  == '' and  asset.field_value.find(fieldObj.id) != nil
        fieldsToDelete.push(fieldObj.id)
        puts asset.inspect
      end
    end

    asset.save
    deleteFields(fieldsToDelete,asset)
    redirect_to :action => 'index'
  end

  def view
    @asset = Asset.find(params[:id])
  end
end
