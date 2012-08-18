class Field < ActiveRecord::Base
  has_one :field_type
  attr_accessible :description, :name, :field_type_id
end
