# frozen_string_literal: true

ActiveAdmin.register_page 'department_with_max_min_value', label: 'asd' do
  menu label: 'Віддил з максимальним і мінімальним прибутком', parent: 'Звіти'

  content title: 'Віддил з максимальним і мінімальним прибутком' do
    min_department = Prod::Department.joins(:orders).group('departments.id')
                                     .select('departments.*, SUM(orders.price * orders.quantity) AS total_price')
                                     .order(total_price: :asc).limit(1).first
    max_department = Prod::Department.joins(:orders).group('departments.id')
                                     .select('departments.*, SUM(orders.price * orders.quantity) AS total_price')
                                     .order(total_price: :desc).limit(1).first

    if min_department.present? && max_department.present?
      text_of_min = "Відділ з мінімальним прибутком: #{min_department.name}"
      text_of_min << ", прибуток за весь час становить: #{min_department.total_price} грн"
      h3 text_of_min

      text_of_max = "Відділ з максимальним прибутком: #{max_department.name}"
      text_of_max << ", прибуток за весь час становить: #{max_department.total_price} грн"
      h3 text_of_max
    end
  end
end
