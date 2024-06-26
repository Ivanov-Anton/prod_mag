# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'Product' do
  actions :all

  config.paginate = false
  filter :department, as: :searchable_select, ajax: true

  permit_params do
    %i[level_of_quality name orders_count price product_category_id quantity_in_stock quantity_sold
       department_id type_of_measure size_of_batch]
  end

  controller do
    def scoped_collection
      super
        .joins(:department)
        .select('products.*, SUM(orders.price * orders.quantity) AS total_profit')
        .left_joins(:orders)
        .group('products.id, departments.name, departments.id')
        .eager_load(:department)
    end
  end

  index do
    selectable_column
    column :name
    column :price
    column :quantity_in_stock
    column :quantity_sold
    column :department
    column :size_of_batch
    column :level_of_quality
    column :type_of_measure do |product|
      Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(product.type_of_measure)
    end
    column 'Прибуток' do |product|
      number_with_delimiter(product.total_profit, delimiter: ' ')
    end
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs do
      f.input :name, input_html: { autofocus: :autofocus }
      f.input :department, as: :searchable_select,
                           ajax: true,
                           hint: link_to('Створити', new_admin_department_path, AaHelper::SECUTORY_OPTIONS)
      f.input :level_of_quality, as: :searchable_select, collection: Prod::Product::CONST::PLAIN_LEVEL_OF_QUALITIES
      f.input :type_of_measure, as: :searchable_select, collection: Prod::Product::CONST::TYPES_OF_MEASURE,
                                selected: Prod::Product::CONST::TYPES_OF_MEASURE_VALUE_EACH
      f.input :price, as: :number, placeholder: 'Ціна в грн', hint: 'Ціна за один товар'
      f.input :quantity_in_stock, as: :number, label: 'Кількість',
                                  input_html: {
                                    value: f.object.quantity_in_stock.zero? ? 1 : f.object.quantity_in_stock
                                  }
      f.input :product_category, as: :searchable_select,
                                 ajax: true,
                                 hint: link_to('Створити', new_admin_product_category_path, AaHelper::SECUTORY_OPTIONS)
      f.input :size_of_batch
    end

    f.actions do
      verb = f.object.persisted? ? 'Оновити' : 'Створити'
      f.action :submit, label: verb.to_s
      f.cancel_link
    end
  end

  searchable_select_options(scope: Prod::Product.all, text_attribute: :name)
end
