class Asset
  include MongoMapper::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks


  key :description, String
  key :name, String
  key :searchable_name, String
  key :asset_name, String
  key :parent_id, Integer
  key :asset_type_id, String
  key :asset_type_name, ObjectId

  key :created_at, Time
  key :created_by, ObjectId

  key :vendor_server_id, Integer

  many :field_value

  has_many :field_value


  mapping do
    indexes :asset_name, :type => 'string', :index => :not_analyzed
    indexes :searchable_name, :type => 'string'
    indexes :description, :type => 'string'
    indexes :asset_type_id, :type => 'string'
    indexes :field_value, :type => 'object'
  end
end
