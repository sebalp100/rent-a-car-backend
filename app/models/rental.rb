class Rental < ApplicationRecord
  belongs_to :car
  belongs_to :user

  enum status: { pending: 'pending', in_progress: 'in_progress', canceled: 'canceled', completed: 'completed', unknown: 'unknown' }

  after_create :update_car_reserved_status

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

  def update_car_reserved_status
    car.update(reserved: true) if car.present?
  end

  
end
