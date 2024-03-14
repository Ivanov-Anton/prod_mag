# frozen_string_literal: true

ActiveAdmin.register Prod::Department, as: 'department' do
  config.create_another = true
  permit_params do
    ["name"]
  end

  index do
    selectable_column
    column :name
    column do |department|
      link_to "Кол-во товаров (#{department.products_count})", admin_products_path(q: { department_id_eq: department.id }), class: 'button'
    end
    column do |department|
      link_to "Кол-во заказов (#{department.orders_count})", admin_orders_path(q: { department_id_eq: department.id }), class: 'button'
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
    end
    f.actions do
      verb = f.object.persisted? ? 'Редактировать' : 'Создать'
      f.action :submit, label: verb
      f.cancel_link
    end
  end
end