class FieldOption < ActiveRecord::Base
  has_one :field
  belongs_to :field
  attr_accessible :field_id, :parent, :option

  searchable do
      text :option
  end
end
