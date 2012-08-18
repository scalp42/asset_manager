class CreateAssetScreens < ActiveRecord::Migration
  def change
    create_table :asset_screens do |t|
      t.string :name
      t.string :description
      t.integer :asset_id
      t.integer :field_id
      t.integer :position

      t.timestamps
    end
  end
end
