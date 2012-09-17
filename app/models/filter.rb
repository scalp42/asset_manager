class Filter
  include MongoMapper::Document

  key :name, String
  key :available, Boolean
  key :user_id, ObjectId
  key :search_criteria, String

end
