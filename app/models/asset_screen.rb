class AssetScreen
  include MongoMapper::EmbeddedDocument
  key  :description, String
  key  :name, String
  key  :parent, String
  key  :required, Boolean

end
