class Filter
  include MongoMapper::Document

  key :name, String
  key :available, Boolean
  key :user_id, ObjectId

  many :filter_details
end
