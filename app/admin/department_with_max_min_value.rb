# frozen_string_literal: true

ActiveAdmin.register_page 'department_with_max_min_value', label: 'asd' do
  menu label: 'Отделы с максимальной и минимальной прибылью', parent: 'Actions'

  content title: 'Отделы с максимальной и минимальной прибылью' do
    min_department = Prod::Department.joins(:orders).group('departments.id').select('departments.*, SUM(orders.price * orders.quantity) AS total_price').order(total_price: :asc).limit(1).first
    max_department = Prod::Department.joins(:orders).group('departments.id').select('departments.*, SUM(orders.price * orders.quantity) AS total_price').order(total_price: :desc).limit(1).first

    if min_department.present? && max_department.present?
      h3 "Отдел с минимальной прибылью: #{min_department.name}, прибыль за все время состевляет всего: #{min_department.total_price} грн"
      h3 "Отдел с максимальной прибылью: #{max_department.name}, прибыль за все время состевляет всего: #{max_department.total_price} грн"
    end
  end
end
