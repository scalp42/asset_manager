class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.integer :field_value_id

      t.timestamps
    end
  end
end
