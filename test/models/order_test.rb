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
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
