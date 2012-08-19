class FieldValue < ActiveRecord::Base
  attr_accessible :numeric_value, :field_option_id, :field_id, :text_value
end
