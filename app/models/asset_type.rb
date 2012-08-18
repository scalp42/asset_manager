class AssetType < ActiveRecord::Base
  attr_accessible :description, :name, :parent
end
