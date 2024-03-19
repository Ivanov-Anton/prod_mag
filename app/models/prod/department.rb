# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id             :bigint           not null, primary key
#  name           :string
#  orders_count   :integer          default(0)
#  products_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module Prod
  class Department < ApplicationRecord

    has_many :products, class_name: 'Prod::Product'
    has_many :orders, class_name: 'Prod::Order'

    validates :name, presence: { message: 'Имя не может быть пустым' }

    def self.ransackable_associations(auth_object = nil)
      ['products', 'orders']
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at id id_value name updated_at]
    end
  end
end
