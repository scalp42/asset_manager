class AssetType
  include MongoMapper::Document
  key  :description, String
  key  :name, String
  key  :parent, String

  many :asset_screen

  validates :name, :presence => true
end
