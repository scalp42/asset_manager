class AdminFieldController < ApplicationController
  layout 'admin'
  include AdminFieldHelper

  def list_fields
    @fields = Field.all.entries
    setSidebar(nil,true,nil,nil,nil)
    render :template => 'admin_field/list_fields'
  end

  def list_asset_types
    @asset_types = AssetType.all.entries
    setSidebar(true,nil,nil,nil,nil)
    render :template => 'admin_field/list_asset_types'
  end

  def create
    newField = Field.new(:field_type_id => params[:field_type][:field_type_id] ,:description => params[:description][:field_type_description],:name => params[:name][:field_type_name])

    if newField.save
      setSidebar(nil,true,nil,nil,nil)
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

    field.wiki_enabled = params['allows_wiki']['allows_wiki']

    if field.save
      setSidebar(nil,true,nil,nil,nil)
      setFieldReturn(field.name,"Edited")
    end
  end

  def list_asset_screen_fields
    listAssetScreens(params[:id])
    setSidebar(true,nil,nil,nil,nil)
  end

  def update_asset_type_screen

    asset = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))
    asset.asset_screen.build(:field_id => params[:field][:field_id] ,:asset_id => params[:asset_type][:asset_type_id],:required =>params[:required][:required])

    if asset.save
      assetScreenReturn(Field.find(params[:field][:field_id]).name,asset.name,"Added")
      listAssetScreens(asset.id)
      setSidebar(true,nil,nil,nil,nil)
      render :template => 'admin_field/list_asset_screen_fields'
    end
  end

  def create_asset_type
    if params[:asset_image] != nil
      newAssetType = AssetType.new(:description => params[:description][:asset_type_description],:name => params[:name][:asset_type_name],:photo => params[:asset_image][:asset_image])
    else
      newAssetType = AssetType.new(:description => params[:description][:asset_type_description],:name => params[:name][:asset_type_name])
    end

    if params[:vendor][:vendor_type_description] != ''
      newAssetType.vendor = params[:vendor][:vendor_type_description]
    end

    if newAssetType.save
      assetTypeReturn(params[:name][:asset_type_name] ,"Created")
      @asset_types = AssetType.all.entries
      setSidebar(true,nil,nil,nil,nil)
      render :template => 'admin_field/list_asset_types'
    else
      puts newAssetType.errors.inspect
    end

  end

  def delete
    if Field.destroy(BSON::ObjectId.from_string(params['field_id']))
      AssetType.each do |assetType|
        assetType.pull(:asset_screen =>{:field_id => params['field_id']})
      end
      Asset.each do |asset|
        asset.pull(:field_value =>{:field_id => BSON::ObjectId.from_string(params['field_id'])} )
      end
      setFieldReturn("","Deleted")
      setSidebar(true,nil,nil,nil,nil)
    end

  end

  def delete_asset_type
    if AssetType.destroy(BSON::ObjectId.from_string(params['asset_type_id']))
      Asset.pull_all(:asset_type_id => params['asset_type_id'])
      assetTypeReturn("","Deleted")
      @asset_types = AssetType.all.entries
      setSidebar(true,nil,nil,nil,nil)
      render :template => 'admin_field/list_asset_types'
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
    setSidebar(nil,true,nil,nil,nil)
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
    setSidebar(nil,true,nil,nil,nil)
  end

  def delete_option

    if Field.pull(BSON::ObjectId.from_string(params['field']['field_id']), {:field_option => {:_id => BSON::ObjectId.from_string(params['option']['option_id'])}})
      @field = Field.find(BSON::ObjectId.from_string(params['field']['field_id']))
      setOptionReturn(@field.name,"","Deleted")
      render :template => 'admin_field/configure_field'
    end
    setSidebar(nil,true,nil,nil,nil)
  end

  def delete_asset_screen
    if AssetType.pull(BSON::ObjectId.from_string(params['asset_id']),{:asset_screen => {:_id => BSON::ObjectId.from_string(params['asset_screen_id'])}})
      asset = AssetType.find(BSON::ObjectId.from_string(params['asset_id']))
      listAssetScreens(asset.id)
      assetScreenReturn("",asset.name,"Removed")
      render :template => 'admin_field/list_asset_screen_fields'
    end
    setSidebar(true,nil,nil,nil,nil)
  end


  def toggle_required

    assetType = AssetType.find(BSON::ObjectId.from_string(params[:id]))

    if params[:required] == 'true'
      assetType.asset_screen.select { |b| b.field_id == params[:field_id] }.each { |b|  b.required = FALSE}
    else
      assetType.asset_screen.select { |b| b.field_id == params[:field_id] }.each { |b|  b.required = TRUE}
    end

    if assetType.save
      listAssetScreens(assetType.id)
      assetScreenReturn("",assetType.name,"Toggled")
      render :template => 'admin_field/list_asset_screen_fields'
    end

  end

  def edit_asset_type_id
    assetType = AssetType.find(BSON::ObjectId.from_string(params[:asset_type_id][:asset_type_id]))

    assetType.name = params[:asset_type_name][:asset_type_name]

    if params[:asset_type_description][:asset_type_description] != nil
      assetType.description = params[:asset_type_description][:asset_type_description]
    end

    if params[:asset_image] != nil
      assetType.photo = params[:asset_image][:asset_image]
    end

    if assetType.save
      assetTypeReturn("","Updated")
      @asset_types = AssetType.all.entries
      setSidebar(true,nil,nil,nil,nil)
      render :template => 'admin_field/list_asset_types'
    end

  end

end
