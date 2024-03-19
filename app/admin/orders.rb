# frozen_string_literal: true

ActiveAdmin.register Prod::Order, as: 'order' do
  actions :index, :show, :create, :new, :destroy
  config.filters = false

  permit_params do
    %w[quantity product_id]
  end

  index do
    selectable_column
    column :price
    column :product
    column :quantity do |order|
      case order&.product&.type_of_measure
      when Prod::Product::CONST::TYPES_OF_MEASURE_VALUE_EACH
        suffix = 'шт'
      else
        suffix = Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(order&.product&.type_of_measure, 'asd')
      end
      "#{order.quantity} #{suffix}"
    end
    column :total_price do |order|
      order.price * order.quantity
    end
    actions
  end

  show do
    attributes_table do
      row :price
      row :quantity
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs do
      f.input :quantity, as: :number, input_html: { autofocus: :autofocus }
      f.input :product, as: :searchable_select, ajax: { resource: 'Product' }
    end
    f.actions do
      verb = f.object.persisted? ? 'Редактировать' : 'Создать'
      f.action :submit, label: verb
      f.cancel_link
    end
  end
end