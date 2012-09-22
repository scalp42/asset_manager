class OverviewColumn
  include MongoMapper::Document

  key :user_id, ObjectId
  key :overview_columns, Array
end
