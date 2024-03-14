# frozen_string_literal: true

class AddDepartmentTable < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :products_count, default: 0
      t.timestamps
    end
  end
end
