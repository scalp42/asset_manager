class AssetScreenSection
  include MongoMapper::EmbeddedDocument
  key :name, String
  key :description, String

  many :asset_screen

end
