class CreateFilterDetails < ActiveRecord::Migration
  def change
    create_table :filter_details do |t|
      t.integer :filter_id
      t.integer :field_id
      t.string :text_search
      t.date :date_search
      t.integer :field_option_id
      t.integer :asset_type_id
      t.string :name
      t.string  :description
      t.timestamps
    end
  end
end
