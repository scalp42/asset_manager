class AdminFieldController < ApplicationController
  layout 'admin'
  include AdminFieldHelper
  include CloudVendorsHelper

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
    listAssetScreens(params[:id],params[:asset_section_id])
    setSidebar(true,nil,nil,nil,nil)
  end

  def list_asset_screen_sections
    @asset_type = AssetType.find(params[:id])
    @section = @asset_type.asset_screen_section.detect {|c|c.name == 'Rackspace Cloud'}
    setSidebar(true,nil,nil,nil,nil)
  end

  def update_asset_type_screen_section
    @asset_type = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))

    @asset_type.asset_screen_section.build(:name => params[:name][:asset_type_section_name])

    if @asset_type.save
      setSidebar(true,nil,nil,nil,nil)
      render :template => 'admin_field/list_asset_screen_sections'
    end
  end

  def delete_asset_section
    if AssetType.pull(BSON::ObjectId.from_string(params['asset_type_id']),{:asset_screen_section => {:_id => BSON::ObjectId.from_string(params['asset_section_id'])}})
      @asset_type = AssetType.find(BSON::ObjectId.from_string(params['asset_type_id']))

      @section = @asset_type.asset_screen_section.detect {|c|c.name == 'Rackspace Cloud'}
      assetScreenReturn("",'Section',"Removed")
      render :template => 'admin_field/list_asset_screen_sections'
    end
    setSidebar(true,nil,nil,nil,nil)
  end

  def update_asset_type_screen

    asset = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))
    section = asset.asset_screen_section.detect {|c|c.id == BSON::ObjectId.from_string(params[:asset_type][:screen_id])}
    params[:field][:field_id].each do |field|
      if field != ''
        section.asset_screen.build(:field_id => field ,:asset_id => params[:asset_type][:asset_type_id],:required =>params[:required][:required])
      end
    end
    if section.save
      assetScreenReturn('Fields',asset.name,"Added")
      listAssetScreens(asset.id,section.id.to_s)
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

      if params[:vendor][:vendor_type_rs] != ''
        newAssetType.vendor_creds = params[:vendor][:vendor_type_rs]
      end

      if params[:vendor][:vendor_type_amazon] != ''
        newAssetType.vendor_creds = params[:vendor][:vendor_type_amazon]
      end
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

  def update_rs_asset_type_screen
    asset = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))
    section = asset.asset_screen_section.build(:name => "Rackspace Cloud")

    if asset.save

    end

    if params[:field][:rs_fields] != ''
      add_rs_fields(params[:field][:rs_fields],asset,section)
      assetScreenReturn("RS Fields",asset.name,"Added")
    end

    listAssetScreens(asset.id,section.id.to_s)
    setSidebar(true,nil,nil,nil,nil)
    render :template => 'admin_field/list_asset_screen_fields'
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
    asset = AssetType.find(BSON::ObjectId.from_string(params['asset_id']))

    section = asset.asset_screen_section.detect {|c|c.id == BSON::ObjectId.from_string(params['asset_section_id'])}

    section.asset_screen.delete_if {|screen| screen.id == BSON::ObjectId.from_string(params['asset_screen_id'])}
    if section.save

      listAssetScreens(asset.id,section.id.to_s)
      assetScreenReturn("",asset.name,"Removed")
      render :template => 'admin_field/list_asset_screen_fields'
    end
    setSidebar(true,nil,nil,nil,nil)
  end


  def toggle_required

    assetType = AssetType.find(BSON::ObjectId.from_string(params[:id]))
    section = assetType.asset_screen_section.detect {|c|c.id == BSON::ObjectId.from_string(params[:asset_section_id])}

    if params[:required] == 'true'
      section.asset_screen.select { |b| b.field_id == params[:field_id] }.each { |b|  b.required = FALSE}
    else
      section.asset_screen.select { |b| b.field_id == params[:field_id] }.each { |b|  b.required = TRUE}
    end

    if section.save
      listAssetScreens(assetType.id,section.id.to_s)
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

  def edit_asset_screen_section
    @asset_type = AssetType.find(BSON::ObjectId.from_string(params[:asset_type_id][:asset_type_id]))

    @section = @asset_type.asset_screen_section.detect {|c|c.name == 'Rackspace Cloud'}
    setSidebar(true,nil,nil,nil,nil)

    @asset_type.asset_screen_section.select { |b| b.id == BSON::ObjectId.from_string(params[:asset_type_id][:section_id]) }.each { |b|  b.name = params[:asset_type_section_name][:asset_type_section_name]}

    if @asset_type.save
      render :template => 'admin_field/list_asset_screen_sections'
    end
  end

end
