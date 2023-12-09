# frozen_string_literal: true

json.extract! user, :id, :email, :password, :password_confirmation, :first_name, :last_name, :phone, :created_at,
              :updated_at
json.url user_url(user, format: :json)
