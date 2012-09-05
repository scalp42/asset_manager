class SecurityScheme
  include MongoMapper::Document

  key :name, String
  key :description, String
  key :restrictions, Array
  key :asset_type_id, ObjectId

end
