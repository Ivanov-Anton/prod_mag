class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.bigint :product_id
      t.bigint :department_id
      t.bigint :product_category_id
      t.decimal :price
      t.integer :quantity
      t.integer :level_of_quality

      t.timestamps
    end
  end
end
