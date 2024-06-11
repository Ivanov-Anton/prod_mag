# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'cost_of_goods_for_replenishment' do
  actions :index
  menu label: 'Вартість товару для поповнення', parent: 'Звіти'
  config.filters = false

  controller do
    def scoped_collection
      super.where('quantity_in_stock < 10')
    end
  end

  index download_links: false, title: 'Вартість товару для поповнення' do
    actions { |product| link_to 'Додати товар', edit_admin_product_path(product) }
    column :name
    column :quantity_in_stock
    column 'Для закупівлі необхідно' do |product|
      t_of_m = Prod::Product::CONST::TYPES_OF_MEASURE.invert.fetch(product.type_of_measure)
      "#{product.price * product.size_of_batch} грн. (для закупівлі #{product.size_of_batch} #{t_of_m.downcase} товара)"
    end
  end
end
