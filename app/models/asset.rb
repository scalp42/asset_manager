class Asset
  include MongoMapper::Document
  include Sunspot::Mongo
  #include Tire::Model::Search
  #include Tire::Model::Callbacks


  key :description, String
  key :name, String
  key :parent_id, Integer
  key :asset_type_id, String
  key :asset_type_name, ObjectId

  many :field_value
  #has_many :field_values, :dependent => :destroy
  #attr_accessible :description, :name, :parent_id, :asset_type_id


  searchable do
     text :name, :description
     text :asset_type_id

    #text :field_value do
    #  field_value.map { |i| i.field_id + ' '+ i.field_option_id }
    #end
  end

end
