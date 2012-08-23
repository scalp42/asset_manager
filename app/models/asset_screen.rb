class AssetScreen
  include MongoMapper::EmbeddedDocument
  key  :description, String
  key  :name, String
  key  :parent, String
  #has_one :field
  #belongs_to :field
  #attr_accessible :asset_id, :description, :field_id, :name, :position
end
