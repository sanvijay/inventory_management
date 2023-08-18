# frozen_string_literal: true

class AddCreatedByToInventories < ActiveRecord::Migration[7.0]
  def change
    add_reference :inventories, :created_by, null: false, foreign_key: { to_table: :users }
  end
end
