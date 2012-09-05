class SecurityScheme
  include MongoMapper::Document

  key :name, String
  key :description, String

  key :asset_type_id, ObjectId

  key :view_restrictions, Hash
  key :edit_restrictions, Hash
  key :create_restrictions, Hash
  key :delete_restrictions, Hash
end
