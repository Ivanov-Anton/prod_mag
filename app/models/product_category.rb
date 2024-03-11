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
class ProductCategory < ApplicationRecord
end
