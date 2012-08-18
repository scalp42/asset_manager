class CreateFieldTypes < ActiveRecord::Migration
  def change
    create_table :field_types do |t|
      t.string :type_name

      t.timestamps
    end
  end
end
