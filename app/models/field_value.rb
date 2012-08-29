class FieldValue
  include MongoMapper::EmbeddedDocument
  plugin Joint

  belongs_to :asset

  key :numeric_value, Integer
  key :field_id, ObjectId
  key :text_value, String
  key :date, Date
  key :parent_field_option_id, ObjectId
  key :field_option_id, Array
  key :field_name_value, Hash

  attachment :file

end
