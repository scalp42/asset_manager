class Filter < ActiveRecord::Base
  attr_accessible :name, :available, :user_id
end
