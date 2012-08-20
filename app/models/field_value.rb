class FieldValue < ActiveRecord::Base
  has_one :asset
  belongs_to :asset
  attr_accessible :numeric_value, :field_option_id, :field_id, :text_value , :asset_id , :date ,:datetime

  searchable do
      text :numeric_value, :text_value , :date, :datetime
  end

end
