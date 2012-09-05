class FieldType
  include MongoMapper::Document

  key :type_name, String
  key :use_date,  Boolean
  key :use_datetime, Boolean
  key :use_option,  Boolean
  key :use_text,  Boolean
  key :use_casecade_option, Boolean

end
