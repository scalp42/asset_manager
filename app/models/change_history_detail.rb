class ChangeHistoryDetail
  include MongoMapper::EmbeddedDocument

  key :previous_value, Array
  key :new_value, Array

  key :string_previous_value, String
  key :string_new_value, String

  belongs_to :change_history
end
