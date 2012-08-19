class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.timestamps
    end
  end
end
