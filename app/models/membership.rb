class Membership
  include MongoMapper::EmbeddedDocument

  key :group_id, ObjectId
  key :user_id, ObjectId

end
