module AdminFieldHelper
  def getParentOptions(field_id)
    field = Field.find(BSON::ObjectId.from_string(field_id))

    parentOptions = Array.new
    field.field_option.each do |field_option|
      if(field_option.parent_field_option == nil)
        parentOptions.push(field_option)
      end
    end

    return parentOptions
  end

  def getChildOptions(parent_field_id)
    puts parent_field_id.inspect

  end

  def setFieldReturn(fieldName,alertType)
    @fieldAlert =  fieldName
    @fieldAlertType = alertType
    @fields = Field.all.entries
    render :template => 'admin_field/list_fields'
  end

  def setOptionReturn(fieldName,selectOption,alertType)
    @fieldAlert = fieldName
    @fieldAlertType = alertType
    @selectOption = selectOption
  end

  def assetScreenReturn(fieldName,assetType,alertType)
    @fieldAlert = fieldName
    @assetType = assetType
    @fieldAlertType = alertType
  end

  def assetTypeReturn(assetType,assetAction)
    @assetAlert = assetType
    @assetAction = assetAction
  end

  def listAssetScreens(asset_id)
    @asset = AssetType.find(asset_id)

    fields = Array.new
    @asset.asset_screen.each do |assetScreen|
      fields.push(Field.find(assetScreen.field_id).name)
    end

    #vendor_fields = Array.new
    #@asset.asset_screen.each do |assetScreen|
    #  if Field.find(assetScreen.field_id).vendor_type == @asset.vendor
    #    vendor_fields.push(Field.find(assetScreen.field_id).name)
    #  end
    #end

    @fieldToBeAdded = Array.new
    Field.all.each do |field|
      if(!fields.include?(field.name))
        @fieldToBeAdded.push(field)
      end
    end

    #@vendorFieldToBeAdded
    #if @asset.vendor != nil
    #  Field.where(:vendor_type => @asset.vendor).each do |field|
    #     if !vendor_fields.include?(field.name)
    #       @vendorFieldToBeAdded.push(field);
    #     end
    #  end
    #end

  end

  def setSidebar(assetsMenu,fieldsMenu,usersMenu,indexMenu,notificationMenu)
    @assetsMenu = assetsMenu
    @fieldsMenu = fieldsMenu
    @usersMenu = usersMenu
    @indexMenu = indexMenu
    @notificationMenu = notificationMenu
  end

  def create_field_option(field,option)
    field.field_option.build(:option => option,:field_id => field.id)
    if field.save

    end
  end

end
