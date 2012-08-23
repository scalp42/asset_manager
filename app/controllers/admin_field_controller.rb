class AdminFieldController < ApplicationController
  layout 'admin'

  def list_fields
    @fields = Field.all.entries
    render :template => 'admin_field/list_fields'
  end

  def list_asset_types
    @asset_types = AssetType.all.entries
    render :template => 'admin_field/list_asset_types'
  end

  def create
    newField = Field.new(:field_type_id => params[:field_type][:field_type_id] ,:description => params[:description][:field_type_description],:name => params[:name][:field_type_name])

    if newField.save
      redirect_to :back
    end

  end

  def list_asset_screen_fields

    @asset = AssetType.find(params[:id])

    fields = Array.new
    @asset.asset_screen.each do |assetScreen|
        fields.push(Field.find(assetScreen.field_id).name)
    end

    puts fields.inspect
    @fieldToBeAdded = Array.new
    Field.all.each do |field|
      if(!fields.include?(field.name))
        @fieldToBeAdded.push(field)
      end
    end

  end

  def update_asset_type_screen

    @asset = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))
    @asset.asset_screen.build(:field_id => params[:field][:field_id] ,:asset_id => params[:asset_type][:asset_type_id])

    if @asset.save
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
    if Field.destroy(BSON::ObjectId.from_string(params['field_id']))
      redirect_to :back
    end

  end

  def delete_asset_type
    #if AssetType.delete(params['asset_type_id'])
    #  redirect_to :back
    #end
  end

  def configure_field
    if(params['value'].present?)
      @field = Field.find(params['field_id']['field_id'])
      @field.field_option.build(:option => params['value']['select_field_value'],:field_id => @field.id)
      @field.save
    else
      @field = Field.find(params['id'])
    end
  end

  def delete_option
    if Field.pull(BSON::ObjectId.from_string(params['field']['field_id']), {:field_option => {:_id => BSON::ObjectId.from_string(params['option']['option_id'])}})
      redirect_to :back
    end
  end

  def delete_asset_screen
    #if AssetScreen.destroy(params['asset_screen_id'])
    #  redirect_to :back
    #end
  end

end
