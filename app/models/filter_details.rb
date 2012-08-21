class FilterDetails < ActiveRecord::Base
  attr_accessible :date_search, :field_id, :filter_id, :field_option_id, :text_search ,:asset_type_id, :name, :description
end
