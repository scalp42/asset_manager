module FieldHelper

  def get_field_types()
    fieldTypes = FieldType.all

    types = Array.new

    fieldTypes.each do |type|
      types[] = type.type_name
    end

    return types
  end
end
