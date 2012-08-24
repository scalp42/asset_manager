class Asset
  include MongoMapper::Document

  key :description, String
  key :name, String
  key :parent_id, Integer
  key :asset_type_id, ObjectId
  key :asset_type_name, String

  many :field_value
  #has_many :field_values, :dependent => :destroy
  #attr_accessible :description, :name, :parent_id, :asset_type_id

  #searchable do
  #  text :name, :description
  #  integer :asset_type_id
  #end

end
