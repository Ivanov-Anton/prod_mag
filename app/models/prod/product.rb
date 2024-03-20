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
  # represent product on the admin UI system
  class Product < ApplicationRecord
    validates :name, presence: true
    validates :level_of_quality, presence: true
    validates :price, presence: true
    validates :quantity_in_stock, presence: true
    validates :type_of_measure, presence: true
    validates :department, presence: true
    validates :product_category, presence: true
    validates :size_of_batch, presence: true

    before_create do
      department.update!(products_count: department.products_count + quantity_in_stock)
    end

    before_update do
      if quantity_in_stock_changed?
        value = Prod::Product.where('department_id = ? AND products.id != ?', department_id, id)
                             .sum(:quantity_in_stock)
        department.update!(products_count: value + quantity_in_stock)
      end
    end

    before_destroy do
      department.update!(products_count: department.products_count - quantity_in_stock)
    end

    # the main module that contains list of constant
    module CONST
      LEVEL_OF_QUALITY_FIRST = 'Первый сорт'
      LEVEL_OF_QUALITY_SECOND = 'Второй сорт'
      LEVEL_OF_QUALITY_THIRD = 'Третий сорт'

      LEVEL_OF_QUALITY_VALUE_FIRST = 1
      LEVEL_OF_QUALITY_VALUE_SECOND = 2
      LEVEL_OF_QUALITY_VALUE_THIRD = 3

      PLAIN_LEVEL_OF_QUALITIES = [1,2,3]

      LEVEL_OF_QUALITIES = {
        LEVEL_OF_QUALITY_FIRST => 1,
        LEVEL_OF_QUALITY_SECOND => 2,
        LEVEL_OF_QUALITY_THIRD => 3
      }.freeze

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
      }.freeze

      freeze
    end

    belongs_to :department, class_name: 'Prod::Department', optional: true
    belongs_to :product_category, class_name: 'Prod::ProductCategory', optional: true
    has_many :orders, class_name: 'Prod::Order', dependent: nil

    def self.ransackable_attributes(_auth_object = nil)
      %w[
        created_at
        department_id
        level_of_quality
        id id_value
        name orders_count
        price product_category_id
        quantity_in_stock
        quantity_sold
        updated_at
        type_of_measure
      ]
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
