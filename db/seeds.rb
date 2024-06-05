# frozen_string_literal: true

# Seeds for Development env
#
deps = [
  'Фрукты и овощи', 'Мясной отдел', 'Молочные продукты', 'Хлебобулочные изделия', 'Напитки', 'Морепродукты',
  'Специи и приправы', 'Детское питание и товары для малышей', 'Кофе и чай', 'Спортивное питание'
]
deps.each do |item|
  Prod::Department.find_or_create_by!(name: item)
end

['Овощи', 'Фрукты', 'Молочные продукты', 'Мясо', 'Хлебобулочные изделия', 'Напитки', 'Рыба', 'Приправы'].each do |item|
  Prod::ProductCategory.find_or_create_by!(name: item)
end

# Create Products
{
  { product_category_name: 'Овощи', department_name: 'Фрукты и овощи' } => %w[Помидоры Огурцы Морковь Картофель Лук],
  { product_category_name: 'Фрукты', department_name: 'Фрукты и овощи' } => %w[Яблоки Бананы Апельсины Груши Киви],
  { product_category_name: 'Мясо', department_name: 'Мясной отдел' } => %w[Говядина Свинина Курица Рыба Индейка],
  { product_category_name: 'Молочные продукты', department_name: 'Молочные продукты' } => %w[
    Молоко Сыр Творог Йогурт Масло
  ],
  { product_category_name: 'Хлебобулочные изделия', department_name: 'Хлебобулочные изделия' } => [
    'Белый хлеб',
    'Ржаной хлеб',
    'Булочки',
    'Багет',
    'Пончики'
  ],
  { product_category_name: 'Напитки', department_name: 'Напитки' } => %w[Coca-Cola Моршинская Fonts Pepsi Sandora],
  { product_category_name: 'Рыба', department_name: 'Морепродукты' } => %w[Лосось Семга Скумбрия Тунец Судак],
  { product_category_name: 'Приправы', department_name: 'Специи и приправы' } => %w[
    Паприка Куркума Карри Кориандр Кинза
  ],
  { product_category_name: 'Специи', department_name: 'Специи и приправы' } => [
    'Черный перец', 'Белый перец', 'Красный перец', 'Зеленый перец', 'Морская соль'
  ]
}.each_pair do |element, product_names|
  product_category_name = element.fetch(:product_category_name)
  product_category = Prod::ProductCategory.find_or_create_by!(name: product_category_name)
  department_name = element.fetch(:department_name)
  department = Prod::Department.find_or_create_by!(name: department_name)
  product_names.each do |product_name|
    Prod::Product.find_or_create_by!(
      name: product_name,
      product_category:,
      level_of_quality: Faker::Number.between(from: 1, to: 3),
      price: Faker::Commerce.price,
      type_of_measure: 'each',
      department:,
      quantity_in_stock: Faker::Number.between(from: 1, to: 300),
      size_of_batch: [20, 300, 50, 500, 10_000, 100, 10, 300, 400].sample
    )
  end
end

# add Orders
1000.times do
  product = Prod::Product.all.sample
  Prod::Order.create!(
    product:,
    product_category: product.product_category,
    department: product.department,
    price: product.price,
    quantity: Faker::Number.between(from: 1, to: 20)
  )
rescue ActiveRecord::RecordInvalid => _e
  next
end

if AdminUser.find_by(role: :seo, email: 'seo@seo.com').nil?
  AdminUser.create!(role: :seo, email: 'seo@seo.com', password: 'password', password_confirmation: 'password')
end

if AdminUser.find_by(role: :manager, email: 'manager@manager.com').nil?
  AdminUser.create!(role: :manager, email: 'manager@manager.com', password: 'password', password_confirmation: 'password')
end

if AdminUser.find_by(role: :guest, email: 'guest@guest.com').nil?
  AdminUser.create!(role: :guest, email: 'guest@guest.com', password: 'password', password_confirmation: 'password')
end
