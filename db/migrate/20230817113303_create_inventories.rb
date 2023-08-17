class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.string :model_number
      t.references :department, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
