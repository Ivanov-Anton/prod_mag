# frozen_string_literal: true

ActiveAdmin.register Prod::Department, as: 'department' do
  permit_params do
    ["name"]
  end
end