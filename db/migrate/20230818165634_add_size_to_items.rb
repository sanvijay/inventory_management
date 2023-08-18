# frozen_string_literal: true

class AddSizeToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :size, :string
  end
end
