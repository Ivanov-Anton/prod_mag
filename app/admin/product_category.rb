# frozen_string_literal: true

ActiveAdmin.register Prod::ProductCategory, as: 'product_category' do
  actions :all
  config.create_another = true
  config.filters = false

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
end
