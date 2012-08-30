class FieldValue
  include MongoMapper::EmbeddedDocument
  plugin AttachIt

  belongs_to :asset

  key :numeric_value, Integer
  key :field_id, ObjectId
  key :text_value, String
  key :date, Date
  key :parent_field_option_id, ObjectId
  key :field_option_id, Array
  key :field_name_value, Hash

  has_attachment :photo, {:styles => { :thumb => '100x100>' },  :storage => 'gridfs' }
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/gif', 'image/png']

end
