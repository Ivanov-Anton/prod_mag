# frozen_string_literal: true

ActiveAdmin.register Prod::Product, as: 'most_valuable_product' do
  actions :index
  menu false
  config.filters = false
  config.paginate = false
  config.max_per_page = 1

  controller do
    def scoped_collection
      Prod::Product.joins(:orders).group('products.id').select('products.*, SUM(orders.price * orders.quantity) AS total_price').order(total_price: :desc).limit(1)
    end
  end

  index download_links: false, title: 'Какой товар дал максимальную прибыль в магазине?' do
    id_column
    column :name
    column :price
    column :quantity_sold
    column 'Прибыль' do |product|
      product.orders.map { |order| order.price * order.quantity }.sum
    end
  end
end
