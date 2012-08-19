class Field < ActiveRecord::Base
  has_one :field_type
  has_many :asset_screens, :dependent => :destroy
  attr_accessible :description, :name, :field_type_id
end
