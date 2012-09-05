class ChangeHistory
  include MongoMapper::Document

  key :asset_id, ObjectId
  key :asset_type_id, ObjectId
  key :changed_at, Time
  key :changed_by, ObjectId

  many :change_history_detail

  has_many :change_history_detail
end
