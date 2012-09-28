class AssetType
  include MongoMapper::Document
  plugin AttachIt

  key  :description, String
  key  :name, String
  key  :parent, String

  key  :vendor, ObjectId
  key  :vendor_creds, ObjectId

  many :asset_screen_section

  validates :name, :presence => true

  has_attachment :photo, {:styles => { :thumb => '20x20>' },  :storage => 'gridfs' }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/gif', 'image/png']

end
