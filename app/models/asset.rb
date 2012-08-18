class Asset < ActiveRecord::Base
  attr_accessible :description, :field_value_id, :name, :parent_id
end
