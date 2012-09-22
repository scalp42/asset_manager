class SearchColumn
  include MongoMapper::Document

  key :user_id, ObjectId
  key :search_columns, Array

end
