# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  ROLES = %i[admin client]

  has_many :rentals, dependent: :destroy
  has_one_attached :avatar
end
