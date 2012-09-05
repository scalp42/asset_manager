class FilterDetail
  include MongoMapper::EmbeddedDocument

  key :date_search, Date
  key :field_id, ObjectId
  key :filter_id, ObjectId
  key :field_option_id, ObjectId
  key :text_search, String
  key :asset_type_id, ObjectId
  key :name, String
  key :description, String

end
