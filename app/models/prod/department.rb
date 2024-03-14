# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id             :bigint           not null, primary key
#  name           :string
#  products_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module Prod
  class Department < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[created_at id id_value name updated_at]
    end
  end
end
