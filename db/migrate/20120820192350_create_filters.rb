class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.boolean :available
      t.integer :user_id
      t.timestamps
    end
  end
end
