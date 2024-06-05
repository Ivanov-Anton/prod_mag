class AddDefaultUsers < ActiveRecord::Migration[7.1]
  def up
    AdminUser.create!(email: 'seo@seo.com', password: 'password', password_confirmation: 'password', role: :seo)
    AdminUser.create!(email: 'manager@manager.com', password: 'password', password_confirmation: 'password', role: :manager)
  end

  def down
    AdminUser.delete_by(email: 'seo@seo.com')
    AdminUser.delete_by(email: 'manager@manager.com')
  end
end
