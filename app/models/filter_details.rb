class FilterDetails < ActiveRecord::Base
  attr_accessible :date_search, :field, :filter_id, :select_search, :text_search
end
