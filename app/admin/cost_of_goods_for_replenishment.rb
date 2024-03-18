# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'cost_of_goods_for_replenishment' do
  actions :index
  menu label: 'Стоимость товаров для пополнения', parent: 'Actions'
  config.filters = false

  controller do
    def scoped_collection
      super.where('quantity_in_stock < 10')
    end
  end

  index download_links: false, title: 'Стоимость товаров для пополнения' do
    actions { |product| link_to 'Добавить товар', edit_admin_product_path(product) }
    column :name
    column :quantity_in_stock
    column 'Для того что закупить товар необходимо' do |product|
      t_of_measure = Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(product.type_of_measure)
      "#{product.price * product.size_of_batch} грн. (для закупки #{product.size_of_batch} #{t_of_measure.downcase} товара)"
    end
  end
end
