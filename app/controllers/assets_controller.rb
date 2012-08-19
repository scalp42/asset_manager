class AssetsController < ApplicationController

  def index
    @assets = Asset.all
  end

  def create
    @asset_type = AssetType.find(params[:id])
  end

  def save
    asset = Asset.new(:name =>params[:name][:name],:description => params[:description][:description],:asset_type_id => params[:asset_type][:asset_type_id])
    asset.save

    AssetScreen.find_all_by_asset_id(params[:asset_type][:asset_type_id]).each do |field|
      fieldObj = Field.find(field)
      if params[fieldObj.name][fieldObj.name] != nil
        if FieldType.find(fieldObj.field_type_id).type_name.include? 'Select'
          fieldValue = FieldValue.new(:asset_id => asset.id ,
                                      :field_option_id => params[fieldObj.name][fieldObj.name],
                                      :field_id => fieldObj.id)
          fieldValue.save
        elsif FieldType.find(fieldObj.field_type_id).type_name.include? 'Text Field'
          fieldValue = FieldValue.new(:asset_id => asset.id,
                                      :text_value => params[fieldObj.name][fieldObj.name],
                                      :field_id => fieldObj.id)
          fieldValue.save
        end

      end
    end

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

  end
end
