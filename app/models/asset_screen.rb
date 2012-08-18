class AssetScreen < ActiveRecord::Base
  attr_accessible :asset_id, :description, :field_id, :name, :position
end
