class AdminFieldController < ApplicationController
  layout 'admin'
  include AdminFieldHelper

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
      setFieldReturn(newField.name,"Created")
    else
      puts flash.inspect
    end

  end

  def edit_field
    field = Field.find(params['field_id']['field_id'])
    if params['field_name']['field_name'] != nil
      field.name = params['field_name']['field_name']
    end

    if params['field_description']['field_description'] != nil
      field.description = params['field_description']['field_description']
    end

    if field.save
      setFieldReturn(field.name,"Edited")
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
    if params[:name][:asset_type_name] != nil
      newAssetType = AssetType.new(:description => params[:description][:asset_type_description],:name => params[:name][:asset_type_name])
    end

    if newAssetType.save
      redirect_to :back
    end
  end

  def delete
    if Field.destroy(BSON::ObjectId.from_string(params['field_id']))
      setFieldReturn("","Deleted")
    end

  end

  def delete_asset_type
    if AssetType.destroy(BSON::ObjectId.from_string(params['asset_type_id']))
      redirect_to :back
    end
  end

  def configure_field
    if params['value'].present?
      @field = Field.find(params['field_id']['field_id'])
      @field.field_option.build(:option => params['value']['select_field_value'],:field_id => @field.id)
      if @field.save
        setOptionReturn(@field.name, params['value']['select_field_value'],"Created")
      end
    else
      @field = Field.find(params['id'])
    end
  end

  def configure_child_field
    if params['value'].present?
      @field = Field.find(params['field_id']['field_id'])
      @field.field_option.build(:option => params['value']['select_field_value'],:field_id => @field.id,:parent_field_option => params['parent_option_id']['parent_option_id'])
      @field.save
      @parentOption = params['parent_option_id']['parent_option_id']
    else
      @field = Field.find(params['field'])
      @parentOption = params['id']
    end

  end

  def delete_option

    if Field.pull(BSON::ObjectId.from_string(params['field']['field_id']), {:field_option => {:_id => BSON::ObjectId.from_string(params['option']['option_id'])}})
      @field = Field.find(BSON::ObjectId.from_string(params['field']['field_id']))
      setOptionReturn(@field.name,"","Deleted")
      render :template => 'admin_field/configure_field'
    end
  end

  def delete_asset_screen
    if AssetType.pull(BSON::ObjectId.from_string(params['asset_id']),{:asset_screen => {:_id => BSON::ObjectId.from_string(params['asset_screen_id'])}})
      redirect_to :back
    end
  end

end
