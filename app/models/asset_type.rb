class AssetType < ActiveRecord::Base
  attr_accessible :description, :name, :parent

  searchable do
      text :name, :description
  end

end
