class FieldValue
  #has_one :asset
  #belongs_to :asset
  #attr_accessible :numeric_value, :field_option_id, :field_id, :text_value , :asset_id , :date ,:datetime
  #
  #searchable do
  #    text :numeric_value, :text_value , :date, :datetime
  #end

  include MongoMapper::EmbeddedDocument
  include Sunspot::Mongo

  key :numeric_value, Integer
  key :field_id, ObjectId
  key :text_value, String
  key :date, Date
  key :parent_field_option_id, ObjectId
  key :field_option_id, Array

  #searchable do
  #  integer :numeric_value
  #  text :text_value
  #  text :field_option_id
  #end

end
