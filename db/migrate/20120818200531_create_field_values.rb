class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.integer :field_id
      t.integer :field_option_id
      t.string  :text_value
      t.float   :numeric_value
      t.integer :asset_id
      t.date    :date
      t.datetime :datetime
      t.timestamps
    end
  end
end
