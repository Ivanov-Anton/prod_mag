# frozen_string_literal: true

class CreateProductCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.integer :products_count, default: 0
      t.integer :orders_count, default: 0

      t.timestamps
    end
  end
end
