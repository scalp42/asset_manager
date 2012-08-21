class CreateFieldTypes < ActiveRecord::Migration
  def change
    create_table :field_types do |t|
      t.string :type_name
      t.boolean :use_option
      t.boolean :use_date
      t.boolean :use_datetime
      t.boolean :use_text
      t.timestamps
    end
  end
end
