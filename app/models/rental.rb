class Rental < ApplicationRecord
  belongs_to :car
  belongs_to :user
  has_noticed_notifications model_name: "Notification"
  has_many :notifications, through: :user, dependent: :destroy

  enum status: { pending: 'pending', in_progress: 'in_progress', canceled: 'canceled', completed: 'completed',
                 unknown: 'unknown' }

  validate :rental_date_cannot_be_in_the_past
  validate :return_date_after_rental_date

  validate :check_date_availability, on: :create

  def rental_date_cannot_be_in_the_past
    errors.add(:rental_date, message: "can't be in the past") if rental_date.present? && rental_date < Date.current
  end

  def return_date_after_rental_date
    if rental_date.present? && return_date.present?
      errors.add(:return_date,
                 message: "must be at least 1 day after rental date") if return_date <= rental_date + 1.day
      errors.add(:return_date, message: "can't be lower than rental date") if return_date < rental_date
    end
  end

  def calculate_status
    current_date = Date.current

    self.status = if status != 'canceled' && current_date < rental_date
                    'pending'
                  elsif status != 'canceled' && current_date.between?(rental_date, return_date)
                    'in_progress'
                  elsif status == 'canceled' && current_date.between?(rental_date, return_date)
                    'canceled'
                  elsif current_date > return_date
                    'completed'
                  else
                    'canceled'
                  end

    save if status_changed?
  end

  private

  def check_date_availability
    overlapping_rental = Rental
      .where("car_id = ?", car_id)
      .where("rental_date <= ? AND return_date >= ?", return_date, rental_date)
      .first
  
    if overlapping_rental.present?
      errors.add(:message, "Car is not available for these dates")
    end
  end

  def update_car_reserved_status
    car.update(reserved: true) if car.present?
  end
end
