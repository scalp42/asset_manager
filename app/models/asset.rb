class Asset
  include MongoMapper::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks


  key :description, String
  key :name, String
  key :parent_id, Integer
  key :asset_type_id, String
  key :asset_type_name, ObjectId

  key :created_at, Time
  key :created_by, ObjectId

  key :vendor_server_id, Integer

  many :field_value

  has_many :field_value

end
