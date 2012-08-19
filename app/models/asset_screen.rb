class AssetScreen < ActiveRecord::Base
  has_one :field
  belongs_to :field
  attr_accessible :asset_id, :description, :field_id, :name, :position
end
