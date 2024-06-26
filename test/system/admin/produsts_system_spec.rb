# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  test 'visit index page' do
    visit admin_products_path

    assert_text 'Создать Товар'
    assert_text 'Товары'
  end

  test 'create a product' do
    subject = proc { click_on 'Создать' }

    Prod::Department.create!(name: 'Bakery')
    Prod::ProductCategory.create!(name: 'Bread')
    visit admin_products_path

    click_link 'Создать Товар'
    select 'Bakery', from: 'Отдел магазина'
    select 'Bread', from: 'Категория товара'
    fill_in 'Имя', with: 'Bread'
    fill_in 'Цена', with: '10'
    fill_in 'Размер партии', with: '300'

    assert_changes -> { Prod::Product.count } do
      subject.call
    end

    assert_text 'Bread'
  end

  test 'edit name of product' do
    department = Prod::Department.create!(name: 'Bakery')
    Prod::ProductCategory.create!(name: 'Bread')
    product = Prod::Product.create!(
      name: 'Bread',
      price: 10,
      department: Prod::Department.last!,
      product_category: Prod::ProductCategory.last!,
      level_of_quality: 1,
      type_of_measure: 'each',
      quantity_in_stock: 5,
      quantity_sold: 0,
      size_of_batch: 20
    )
    assert department.reload.products_count == 5
    visit admin_product_path(product)

    click_link 'Изменить Товар'
    fill_in 'Имя', with: 'Bread2'
    click_on 'Обновить'
    assert_text 'Bread2'
    err_msg = "Department products count should be 5, but it is #{department.reload.products_count}"
    assert department.reload.products_count == 5, err_msg
  end

  test 'edit quantity_in_stock of product' do
    department = Prod::Department.create!(name: 'Bakery')
    Prod::ProductCategory.create!(name: 'Bread')
    product = Prod::Product.create!(
      name: 'Bread',
      price: 10,
      department: Prod::Department.last!,
      product_category: Prod::ProductCategory.last!,
      level_of_quality: 1,
      type_of_measure: 'each',
      quantity_in_stock: 5,
      quantity_sold: 0,
      size_of_batch: 20
    )
    assert department.reload.products_count == 5
    visit admin_product_path(product)

    click_link 'Изменить Товар'
    fill_in 'Кол-во', with: '6'
    click_on 'Обновить'
    assert department.reload.products_count == 6
  end

  test 'edit "quantity_in_stock" of product with other products' do
    department = Prod::Department.create!(name: 'Bakery')
    Prod::ProductCategory.create!(name: 'Bread')
    product = Prod::Product.create!(
      name: 'Bread',
      price: 10,
      department: Prod::Department.last!,
      product_category: Prod::ProductCategory.last!,
      level_of_quality: 1,
      type_of_measure: 'each',
      quantity_in_stock: 5,
      quantity_sold: 0,
      size_of_batch: 300
    )
    Prod::Product.create!(
      name: 'Bread 2',
      price: 10,
      department: Prod::Department.last!,
      product_category: Prod::ProductCategory.last!,
      level_of_quality: 1,
      type_of_measure: 'each',
      quantity_in_stock: 5,
      quantity_sold: 0,
      size_of_batch: 300
    )
    assert department.reload.products_count == 10
    visit admin_product_path(product)

    click_link 'Изменить Товар'
    fill_in 'Кол-во', with: '6'
    click_on 'Обновить'
    err_msg = "Department products count should be 11, but it is #{department.reload.products_count}"
    assert department.reload.products_count == 11, err_msg
  end

  test 'when there is one product and delete them' do
    visit admin_product_path(Prod::Product.last!)
    accept_confirm { click_link 'Удалить Товар' }
    assert_text 'Пока нет Товары. Создать'
    assert Prod::Product.count.zero?, "Product count should be 0, but it is #{Prod::Product.count}"
    err_msg = "Department products count should be 0, but it is #{Prod::Department.last!.products_count}"
    assert Prod::Department.last!.products_count.zero?, err_msg
  end

  test 'when there is two products and delete one of them' do
    second_product = Prod::Product.create!(
      name: 'Bread',
      price: 10,
      department: Prod::Department.last!,
      product_category: Prod::ProductCategory.last!,
      level_of_quality: 1,
      type_of_measure: 'each',
      quantity_in_stock: 5,
      quantity_sold: 0,
      size_of_batch: 20
    )

    visit admin_product_path(second_product)
    accept_confirm { click_link 'Удалить Товар' }
    assert_text 'Товары'
    assert Prod::Product.count == 1, "Product count should be 1, but it is #{Prod::Product.count}"
    err_msg = "Department products count should be 10, but it is #{Prod::Department.last!.products_count}"
    assert Prod::Department.last!.products_count == 10, err_msg
  end
end
