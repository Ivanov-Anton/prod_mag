# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'Product' do
  actions :all

  permit_params do
    [:level_of_quality, :name, :orders_count, :price, :product_category_id, :quantity_in_stock, :quantity_sold, :department_id, :type_of_measure]
  end

  index title: 'Товары' do
    actions
    selectable_column
    id_column
    column 'Имя', &:name
    column 'Кол-во проданых товаров', &:orders_count
    column 'Цена', &:price
    column 'Кол-во доступных продуктов', &:quantity_in_stock
    column 'Кол-во проданых товаров', &:quantity_sold
    column 'Отдел', &:department_ids
    column 'Уровень качества', &:level_of_quality
    column 'Мера', &:type_of_measure
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :department_ids, as: :select, collection: Prod::Department.all, label: 'Department', input_html: { multiple: true }
    end

    f.actions
  end
end
