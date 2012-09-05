class NotificationScheme
  include MongoMapper::Document

  key :name, String
  key :description, String

  key :email_addresses, Array
  key :users, Array

end
