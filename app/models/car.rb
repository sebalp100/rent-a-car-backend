class Car < ApplicationRecord
  has_many :rentals, dependent: :destroy
  belongs_to :brand
  has_one_attached :photo
end
