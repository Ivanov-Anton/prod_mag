# frozen_string_literal: true

require 'application_system_test_case'

class DepartmentSystemTest < ApplicationSystemTestCase
  test 'visit index page' do
    visit admin_departments_path

    assert_text 'Отделы магазина'
    assert_text 'Department 1'
    assert_text 'Всего прибыли'
    assert_link 'Изменить'
    assert_link 'Открыть'
    assert_link 'Удалить'
    assert_text '20.0 грн.'
  end

  test 'visit and submit empty form' do
    subject = proc { click_button 'Создать' }

    visit new_admin_department_path

    assert_no_changes -> { Prod::Department.count }, 'Expect there to NOT create department without name, but instead of this created one Department' do
      subject.call
    end
  end
end
