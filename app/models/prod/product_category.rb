# == Schema Information
#
# Table name: product_categories
#
#  id             :bigint           not null, primary key
#  name           :string
#  orders_count   :integer
#  products_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module Prod
  class ProductCategory < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      ["name"]
    end
  end
end
