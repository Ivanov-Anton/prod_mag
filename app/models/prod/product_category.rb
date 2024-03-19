# frozen_string_literal: true

# == Schema Information
#
# Table name: product_categories
#
#  id             :bigint           not null, primary key
#  name           :string
#  orders_count   :integer          default(0)
#  products_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module Prod
  # no doc
  class ProductCategory < ApplicationRecord
    validates :name, presence: { message: 'Имя не может быть пустым' }

    def self.ransackable_attributes(_auth_object = nil)
      ['name']
    end
  end
end
