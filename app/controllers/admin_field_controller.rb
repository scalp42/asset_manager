class AdminFieldController < ApplicationController
  layout 'admin'

  def list_fields
    @fields = Field.all
    render :template => 'admin_field/list_fields'
  end

  def list_asset_types
    @asset_types = AssetType.all
    render :template => 'admin_field/list_asset_types'
  end

  def create
    newField = Field.new(:field_type_id => params[:field_type][:field_type_id] ,:description => params[:description][:field_type_description],:name => params[:name][:field_type_name])

    if newField.save
      redirect_to :back
    end

  end

  def list_asset_screen_fields
     @assetScreens = AssetScreen.find_all_by_asset_id(params[:id])
     @asset = AssetType.find(params[:id])
  end

  def update_asset_type_screen
    newAssetScreen = AssetScreen.new(:field_id => params[:field_type][:field_type_id] ,:asset_id => params[:asset_type_id])

    if newAssetScreen.save
      redirect_to :back
    end
  end

  def create_asset_type
    newAssetType = AssetType.new(:description => params[:description][:asset_type_description],:name => params[:name][:asset_type_name])

    if newAssetType.save
      redirect_to :back
    end
  end

  def delete
    if Field.destroy(params['field_id'])
         redirect_to :back
       end
  end

  def delete_asset_type
    if AssetType.delete(params['asset_type_id'])
        redirect_to :back
    end
  end

  def configure_field
    if(params['value'].present?)
      @field = Field.find(params['field_id']['field_id'])
      fieldOption = FieldOption.new(:option => params['value']['select_field_value'],:field_id => @field.id)
      fieldOption.save
    else
     @field = Field.find(params['id'])
    end
  end

  def delete_option
    if FieldOption.destroy(params['option_id'])
      redirect_to :back
    end
  end

  def delete_asset_screen
    if AssetScreen.destroy(params['asset_screen_id'])
         redirect_to :back
       end
  end

end
