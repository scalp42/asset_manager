class Field
  #has_one :field_type
  #has_many :asset_screens, :dependent => :destroy
  #has_many :field_options, :dependent => :destroy
  #attr_accessible :description, :name, :field_type_id

  include MongoMapper::Document

  key :description, String
  key :name,  String
  key :field_type_id,  String

  validates :field_type_id, :presence => true
  validates :name, :presence =>  true

  many :field_option
  one :field_type
end
