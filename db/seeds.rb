# frozen_string_literal: true

# Seeds for Development env
#
deps = [
  'Фрукти і овочі', 'Мясний відділ', 'Молочні продукти', 'Хлібобулочні вироби', 'Напої', 'Морепродукти',
  'Спеції та приправи', 'Дитяче харчування та товари для малюків', 'Кофе та чай', 'Спортивне харчування'
]
deps.each do |item|
  Prod::Department.find_or_create_by!(name: item)
end

['Овочі', 'Фрукти', 'Молочні продукти', 'Мʼясо', 'Хлібобулочні вироби', 'Напої', 'Рыба', 'Приправы'].each do |item|
  Prod::ProductCategory.find_or_create_by!(name: item)
end

# Create Products
{
  { product_category_name: 'Овочі', department_name: 'Фрукти і овочі' } => %w[Помідори Огірки Марква Картопля Лук],
  { product_category_name: 'Фрукти', department_name: 'Фрукти і овочі' } => %w[Яблука Банани Апельсини Груша Ківі],
  { product_category_name: 'Мʼясо', department_name: 'Мясний відділ' } => %w[Яловичина Свинина Кірка Ріба Індичка],
  { product_category_name: 'Молочні продукти', department_name: 'Молочні продукти' } => %w[
    Молоко Сір Творог Йогурт Масло
  ],
  { product_category_name: 'Хлібобулочні вироби', department_name: 'Хлібобулочні вироби' } => [
    'Білий хліб',
    'Житній хліб',
    'Булочки',
    'Багет',
    'Пончики'
  ],
  { product_category_name: 'Напої', department_name: 'Напої' } => %w[Coca-Cola Моршинская Fonts Pepsi Sandora],
  { product_category_name: 'Риба', department_name: 'Морепродукти' } => %w[Лосось Сьомга Скумбрія Тунець Судак],
  { product_category_name: 'Приправы', department_name: 'Спеції та приправи' } => %w[
    Паприка Куркума Карри Кориандр Кинза
  ],
  { product_category_name: 'Специи', department_name: 'Спеції та приправи' } => [
    'Червоний перець', 'Білий перець', 'Золотий перець', 'Зелений перець', 'Морская сіль'
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
