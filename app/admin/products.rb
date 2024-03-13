# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'Product' do
  actions :all

  permit_params do
    [:level_of_quality, :name, :orders_count, :price, :product_category_id, :quantity_in_stock, :quantity_sold, :department_id, :type_of_measure]
  end

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :quantity_in_stock
    column :quantity_sold
    column :department
    column :level_of_quality do |product|
      Prod::Product::CONST::LEVEL_OF_QUALITIES.invert.fetch(product.level_of_quality)
    end
    column :type_of_measure do |product|
      Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(product.type_of_measure)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name, input_html: { autofocus: :autofocus }
      f.input :department, as: :searchable_select, collection: Prod::Department.all
      f.input :level_of_quality, as: :searchable_select, collection: Prod::Product::CONST::LEVEL_OF_QUALITIES
      f.input :type_of_measure, as: :searchable_select, collection: Prod::Product::CONST::TYPES_OF_MEASURE
      f.input :price, as: :number, placeholder: 'Цена в грн', hint: 'Цена за один товар'
      f.input :quantity_in_stock, as: :number, label: 'Кол-во'
      f.input :product_category, as: :searchable_select, collection: Prod::ProductCategory.all
    end

    f.actions do
      verb = f.object.persisted? ? 'Обновить' : 'Создать'
      f.action :submit, label: "#{verb}"
      f.cancel_link
    end
  end
end
