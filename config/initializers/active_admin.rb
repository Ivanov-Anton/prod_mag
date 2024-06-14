# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.before_action do
    left_sidebar! if respond_to?(:left_sidebar!)
  end
  config.site_title = 'Продмаг'
  config.site_title_link = '/admin/products'
  config.site_title_image = 'logo.jpg'
  config.authentication_method = :authenticate_admin_user!
  config.authorization_adapter = ActiveAdmin::PunditAdapter
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.root_to = 'dashboard#index'
  config.comments = false
  config.batch_actions = true
  config.filter_attributes = %i[encrypted_password password password_confirmation]
  config.localize_format = :long
  config.favicon = 'favicon.ico'
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: 'Звіти', priority: 1
    end
  end
  config.include_default_association_filters = true
  greeting = 'Програмное забеспечення для Директора продовольчого магазина'
  separator = ' , '
  version_info = 'версия 1.0.0 </br> <a href="https://prod-mag.betteruptime.com"> Статус сторінка</a>'
  footer = [greeting, separator, version_info].join
  config.footer = footer.html_safe
end
