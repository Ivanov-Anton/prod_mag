class AddProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :department_id
      t.integer :quantity_sold
      t.integer :quantity_in_stock
      t.integer :product_category_id
      t.integer :orders_count
      t.integer :level_of_quality
      t.string :type_of_measure

      t.timestamps
    end
  end
end
