# frozen_string_literal: true

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

    validates :product, presence: true

    before_validation do
      if product.present?
        errors.add(:base, 'Товары закончились') if product.quantity_in_stock.zero?
        string = product.quantity_in_stock > 1 ? 'товаров' : 'товар'
        errors.add(:base, "Недостаточно товаров на складе, доступно только #{product.quantity_in_stock} #{string}") if product.quantity_in_stock.positive? && quantity > product.quantity_in_stock
      end
    end

    before_create do
      self.price = product.price
      self.level_of_quality = product.level_of_quality
      self.department_id = product.department_id
      self.product_category_id = product.product_category_id

      product.update!(orders_count: product.orders_count + 1, quantity_in_stock: product.quantity_in_stock - quantity, quantity_sold: product.quantity_sold + quantity)
      product.department.update!(orders_count: product.department.orders_count + 1, products_count: product.quantity_in_stock)
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at updated_at id id_value level_of_quality price quantity department_id product_category_id product_id]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[department product product_category]
    end
  end
end
