class Asset
  include MongoMapper::Document

  key :description, String
  key :name, String
  key :parent_id, Integer
  key :asset_type_id, Integer

  many :field_values
  #has_many :field_values, :dependent => :destroy
  #attr_accessible :description, :name, :parent_id, :asset_type_id

  #searchable do
  #  text :name, :description
  #  integer :asset_type_id
  #end

end
