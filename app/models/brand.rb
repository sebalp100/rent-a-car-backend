class Brand < ApplicationRecord
  has_many :cars, dependent: :destroy
  has_one_attached :photo
end
