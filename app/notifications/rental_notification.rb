# To deliver this notification:
#
# RentalNotification.with(post: @post).deliver_later(current_user)
# RentalNotification.with(post: @post).deliver(current_user)

class RentalNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    rental = params[:rental]
    car_info = rental[:car]

    {
      id: rental[:id],
      car_id: rental[:car_id],
      model: car_info[:model],
      year: car_info[:year],
      price: car_info[:price],
      rental_date: rental[:rental_date]
    }
  end
end
