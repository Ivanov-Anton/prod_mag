# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'receive_products_by_department' do
  menu false
  actions :index
  config.filters = false

  before_action only: [:index] do
    @department_id = params['Выберите отдел магазина']
  end

  controller do
    def scoped_collection
      resource_class.where(department_id: params['Выберите отдел магазина'])
    end
  end

  #
  index title: proc { "Список товаров отдела магазина '#{Prod::Department.find(@department_id).name}'" }, download_links: false do
    selectable_column
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
end