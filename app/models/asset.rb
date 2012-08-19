class Asset < ActiveRecord::Base
  has_many :field_values, :dependent => :destroy
  attr_accessible :description, :name, :parent_id, :asset_type_id
end
