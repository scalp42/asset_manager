class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.field_id :int
      t.field_option_id :int
      t.text_value :string
      t.numeric_value :float

      t.timestamps
    end
  end
end
