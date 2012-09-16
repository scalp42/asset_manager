class NotificationScheme
  include MongoMapper::Document

  key :name, String
  key :description, String

  key :asset_type_id, ObjectId

  key :create_email, Hash
  key :edit_email, Hash
  key :delete_email, Hash

end
