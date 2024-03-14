# == Schema Information
#
# Table name: orders
#
#  id                  :bigint           not null, primary key
#  level_of_quality    :integer
#  price               :decimal(, )
#  quantity            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  department_id       :bigint
#  product_category_id :bigint
#  product_id          :bigint
#
module Prod
  class Order < ApplicationRecord
    self.table_name = 'orders'

    belongs_to :department, class_name: 'Prod::Department', optional: true
    belongs_to :product_category, class_name: 'Prod::ProductCategory', optional: true
    belongs_to :product, class_name: 'Prod::Product', optional: true

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at updated_at id id_value level_of_quality price quantity department_id product_category_id product_id]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[department product product_category]
    end
  end
end
