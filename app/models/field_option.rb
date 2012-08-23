class FieldOption
  include MongoMapper::EmbeddedDocument

  key :field_id, String
  key :parent, Integer
  key :option,  String

  #searchable do
  #    text :option
  #end

end
