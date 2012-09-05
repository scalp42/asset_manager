class Field
  include MongoMapper::Document

  key :description, String
  key :name,  String
  key :field_type_id,  String

  validates :field_type_id, :presence => true
  validates :name, :presence =>  true

  many :field_option
  one :field_type
end
