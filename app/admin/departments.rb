# frozen_string_literal: true

ActiveAdmin.register Prod::Department, as: 'department' do
  actions :all
  config.filters = false
  config.create_another = true
  permit_params do
    ['name']
  end

  controller do
    def scoped_collection
      super.left_joins(:orders).select('departments.*, COALESCE(SUM(orders.price * orders.quantity), 0) AS total_profit').group('departments.id')
    end
  end

  index download_links: [:csv] do
    selectable_column
    column :name
    column 'Кол-во продуктов' do |department|
      link_to(
        "Кол-во товаров (#{department.products_count})",
        admin_products_path(q: { department_id_eq: department.id }),
        class: 'button'
      )
    end
    column 'Продажи' do |department|
      link_to(
        "Кол-во продаж (#{department.orders_count})",
        admin_orders_path(q: { department_id_eq: department.id }),
        class: 'button'
      )
    end
    column('Всего прибыли', sortable: :total_profit) do |department|
      "#{number_with_delimiter(department.total_profit, delimiter: ' ')} грн."
    end
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs do
      f.input :name, input_html: { autofocus: :autofocus }
    end

    f.actions do
      f.add_create_another_checkbox
      verb = f.object.persisted? ? 'Редактировать' : 'Создать'
      f.action :submit, label: verb
      f.cancel_link
    end
  end

  searchable_select_options(scope: Prod::Department.all, text_attribute: :name)
end
