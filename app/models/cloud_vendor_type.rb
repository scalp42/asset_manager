class CloudVendorType
  include MongoMapper::Document

  key :vendor_name, String
  key :vendor_description, String
end
