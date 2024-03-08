# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  level_of_quality    :integer
#  name                :string
#  orders_count        :integer
#  price               :decimal(, )
#  quantity_in_stock   :integer
#  quantity_sold       :integer
#  type_of_measure     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  department_id       :integer
#  product_category_id :integer
#
module Prod
  class Product < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[created_at department_ids level_of_quality id id_value name orders_count price product_category_id quantity_in_stock quantity_sold updated_at]
    end
  end
end
