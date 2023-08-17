# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :model_number
      t.text :description
      t.string :reference_url
      t.string :image_url

      t.timestamps
    end
  end
end
