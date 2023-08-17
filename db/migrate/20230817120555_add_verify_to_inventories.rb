class AddVerifyToInventories < ActiveRecord::Migration[7.0]
  def change
    add_column :inventories, :state, :string, null: false, default: 'created'
    add_column :inventories, :verified_at, :datetime
    add_reference :inventories, :verified_by, null: true, foreign_key: { to_table: :users }
  end
end