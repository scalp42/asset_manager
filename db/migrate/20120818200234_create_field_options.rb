class CreateFieldOptions < ActiveRecord::Migration
  def change
    create_table :field_option do |t|
      t.field_id :int
      t.option :string
      t.int :parent

      t.timestamps
    end
  end
end
