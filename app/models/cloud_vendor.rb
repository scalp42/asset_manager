class CloudVendor
  include MongoMapper::Document

  key :cloud_vendor_type, ObjectId
  key :aws_access_key_id, String
  key :aws_secret_access_key, String

  key :username, String
  key :api_key, String
end
