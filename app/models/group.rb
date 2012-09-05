class Group
  include MongoMapper::Document

  many :membership
  has_many :membership

end
