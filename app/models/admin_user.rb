# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("guest"), not null
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  module CONST # :nodoc:
    GUEST_ROLE_NAME = 'guest'
    SEO_ROLE_NAME = 'seo'
    MANAGER_ROLE_NAME = 'manager'

    DEFAULT_ROLE = GUEST_ROLE_NAME

    freeze
  end

  enum role: {
    guest: CONST::GUEST_ROLE_NAME,
    seo: CONST::SEO_ROLE_NAME,
    manager: CONST::MANAGER_ROLE_NAME
  }, _default: CONST::DEFAULT_ROLE

  def display_name
    "#{role} | #{email}"
  end
end
