class Rental < ApplicationRecord
  belongs_to :car
  belongs_to :user

  after_create :update_car_reserved_status

  private

  def update_car_reserved_status
    car.update(reserved: true) if car.present?
  end
end
