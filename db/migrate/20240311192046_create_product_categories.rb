class CreateProductCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.integer :products_count
      t.integer :orders_count

      t.timestamps
    end
  end
end
