class CreateFieldOptions < ActiveRecord::Migration
  def change
    create_table :field_options do |t|
      t.integer :field_id
      t.string :option
      t.integer :parent
      t.timestamps
    end
  end
end
