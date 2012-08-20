class CreateFilterDetails < ActiveRecord::Migration
  def change
    create_table :filter_details do |t|
      t.integer :filter_id
      t.field_id :field
      t.string :text_search
      t.date :date_search
      t.field_option_id :select_search

      t.timestamps
    end
  end
end
