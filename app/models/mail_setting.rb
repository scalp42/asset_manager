class MailSetting
  include MongoMapper::Document

  key :name, String
  key :description, String
  key :server, String
  key :port, Integer
  key :username, String
  key :password, String
  key :from_email, String

end
