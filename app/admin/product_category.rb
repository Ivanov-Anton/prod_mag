# frozen_string_literal: true

ActiveAdmin.register Prod::ProductCategory, as: 'product_category' do
  actions :all

  permit_params do
    [:name]
  end

  index do
    actions
    column :name
  end

  show do
    attributes_table do
      row :name
    end
  end
end
