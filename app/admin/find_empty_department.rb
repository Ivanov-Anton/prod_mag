# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'find_empty_department' do
  menu false
  actions :index
  config.filters = false

  before_action only: [:index] do
    if scoped_collection.empty?
      flash[:notice] = 'Все отделы заполнены товарами'
      redirect_back(fallback_location: '')
    end
  end

  controller do
    def scoped_collection
      resource_class.where(quantity_in_stock: 0).includes(:department).order('departments.name')
    end
  end

  index download_links: false, title: 'Какие товары по отделам отсутствуют' do
    selectable_column
    column :name
    column :price
    column :quantity_in_stock
    column :quantity_sold
    column :department, sortable: 'departments.id'
    column :level_of_quality do |product|
      Prod::Product::CONST::LEVEL_OF_QUALITIES.invert.fetch(product.level_of_quality)
    end
    column :type_of_measure do |product|
      Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(product.type_of_measure)
    end
    actions
  end
end