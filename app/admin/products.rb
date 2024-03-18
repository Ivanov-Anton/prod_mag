# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'Product' do
  actions :all

  config.filters = false

  permit_params do
    [:level_of_quality, :name, :orders_count, :price, :product_category_id, :quantity_in_stock, :quantity_sold, :department_id, :type_of_measure, :size_of_batch]
  end

  action_item :product_by_specific_department, only: :index do

    link_to 'Список товаров в отделе магазинов',
            admin_receive_products_by_departments_path,
            class: 'modal-link',
            data: {
              method: :get,
              inputs: {
                'Выберите отдел магазина': Prod::Department.all.map { |department| [department.name, department.id] }
              }.to_json
            }
  end

  index do
    selectable_column
    column :name
    column :price
    column :quantity_in_stock
    column :quantity_sold
    column :department
    column :size_of_batch
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
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name, input_html: { autofocus: :autofocus }
      f.input :department, as: :searchable_select, collection: Prod::Department.all, hint: link_to('Создать отдел', new_admin_department_path, target: '_blank')
      f.input :level_of_quality, as: :searchable_select, collection: Prod::Product::CONST::LEVEL_OF_QUALITIES, selected: Prod::Product::CONST::LEVEL_OF_QUALITY_VALUE_FIRST
      f.input :type_of_measure, as: :searchable_select, collection: Prod::Product::CONST::TYPES_OF_MEASURE, selected: Prod::Product::CONST::TYPES_OF_MEASURE_VALUE_EACH
      f.input :price, as: :number, placeholder: 'Цена в грн', hint: 'Цена за один товар'
      f.input :quantity_in_stock, as: :number, label: 'Кол-во', input_html: { value: f.object.quantity_in_stock.zero? ? 1 : f.object.quantity_in_stock }
      f.input :product_category, as: :searchable_select, collection: Prod::ProductCategory.all, hint: link_to('Создать категорию', new_admin_product_category_path, target: '_blank')
      f.input :size_of_batch
    end

    f.actions do
      verb = f.object.persisted? ? 'Обновить' : 'Создать'
      f.action :submit, label: "#{verb}"
      f.cancel_link
    end
  end
end
