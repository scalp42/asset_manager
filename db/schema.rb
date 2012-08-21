# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120820192527) do

  create_table "asset_screens", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "asset_id"
    t.integer  "field_id"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "asset_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_id"
    t.integer  "asset_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "field_options", :force => true do |t|
    t.integer  "field_id"
    t.string   "option"
    t.integer  "parent"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "field_types", :force => true do |t|
    t.string   "type_name"
    t.boolean  "use_option"
    t.boolean  "use_date"
    t.boolean  "use_datetime"
    t.boolean  "use_text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "field_values", :force => true do |t|
    t.integer  "field_id"
    t.integer  "field_option_id"
    t.string   "text_value"
    t.float    "numeric_value"
    t.integer  "asset_id"
    t.date     "date"
    t.datetime "datetime"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "field_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "filter_details", :force => true do |t|
    t.integer  "filter_id"
    t.integer  "field_id"
    t.string   "text_search"
    t.date     "date_search"
    t.integer  "field_option_id"
    t.integer  "asset_type_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.boolean  "available"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
