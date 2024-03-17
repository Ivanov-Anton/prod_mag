# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  level_of_quality    :integer
#  name                :string
#  orders_count        :integer          default(0)
#  price               :decimal(, )
#  quantity_in_stock   :integer          default(0)
#  quantity_sold       :integer          default(0)
#  size_of_batch       :integer
#  type_of_measure     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  department_id       :integer
#  product_category_id :integer
#
module Prod
  class Product < ApplicationRecord
    validates :name, presence: { message: 'Имя может быть пустым' }
    validates :level_of_quality, presence: { message: 'Сорт товара не может быть пустым' }
    validates :price, presence: { message: 'Цена не может быть пустой' }
    validates :quantity_in_stock, presence: { message: 'Количество не может быть пусты' }
    validates :type_of_measure, presence: { message: 'Тип измерения не может быть пустым' }
    validates :department, presence: { message: 'Отдел магазина не может быть пустым' }
    validates :product_category, presence: { message: 'Категория товара не может быть пустым' }

    before_create do
      self.department.update!(products_count: self.department.products_count + quantity_in_stock)
    end

    before_update do
      if quantity_in_stock_changed?
        value = Prod::Product.where('department_id = ? AND products.id != ?', self.department_id, self.id).sum(:quantity_in_stock)
        department.update!(products_count: value + quantity_in_stock)
      end
    end

    before_destroy do
      self.department.update!(products_count: self.department.products_count - quantity_in_stock)
    end

    module CONST
      LEVEL_OF_QUALITY_FIRST = 'Первый сорт'
      LEVEL_OF_QUALITY_SECOND = 'Второй сорт'
      LEVEL_OF_QUALITY_THIRD = 'Третий сорт'

      LEVEL_OF_QUALITY_VALUE_FIRST = 1
      LEVEL_OF_QUALITY_VALUE_SECOND = 2
      LEVEL_OF_QUALITY_VALUE_THIRD = 3

      LEVEL_OF_QUALITIES = {
        LEVEL_OF_QUALITY_FIRST => 1,
        LEVEL_OF_QUALITY_SECOND => 2,
        LEVEL_OF_QUALITY_THIRD => 3
      }

      TYPES_OF_MEASURE_KG = 'Колограммы'
      TYPES_OF_MEASURE_LITERS = 'Литры'
      TYPES_OF_MEASURE_EACH = 'Поштучно'
      TYPES_OF_MEASURE_TONNES = 'Тонны'

      TYPES_OF_MEASURE_VALUE_KG = 'kg'
      TYPES_OF_MEASURE_VALUE_LITERS = 'liters'
      TYPES_OF_MEASURE_VALUE_EACH = 'each'
      TYPES_OF_MEASURE_VALUE_TONNES = 'tonnes'

      TYPES_OF_MEASURE = {
        TYPES_OF_MEASURE_KG => 'kg',
        TYPES_OF_MEASURE_LITERS => 'liters',
        TYPES_OF_MEASURE_EACH => 'each',
        TYPES_OF_MEASURE_TONNES => 'tonnes'
      }

      freeze
    end

    belongs_to :department, class_name: 'Prod::Department', foreign_key: :department_id, optional: true
    belongs_to :product_category, class_name: 'Prod::ProductCategory', foreign_key: :product_category_id, optional: true
    has_many :orders, class_name: 'Prod::Order'

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at department_id level_of_quality id id_value name orders_count price product_category_id quantity_in_stock quantity_sold updated_at type_of_measure]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end
  end
end
