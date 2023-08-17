# frozen_string_literal: true

class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :item_version, null: false
      t.references :department, null: false, foreign_key: true
      t.integer :requested_quantity

      t.timestamps
    end
  end
end
