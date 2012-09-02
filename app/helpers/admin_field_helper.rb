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
end
