class Filter
  include MongoMapper::Document
  #attr_accessible :name, :available, :user_id

  key :name, String
  key :available, Boolean
  key :user_id, ObjectId

  many :filter_details
end
