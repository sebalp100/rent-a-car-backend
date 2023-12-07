# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix

  respond_to :json

  def notifications
    user_notifications = current_user.notifications
    formatted_notifications = user_notifications.map { |notification| format_notification(notification) }

    render json: formatted_notifications
  end


  private

  def format_notification(notification)
    rental_info = notification.params[:params][:rental]
    car_info = Car.find(rental_info[:car_id])
  
    {
      id: notification.id,
      recipient_type: notification.recipient_type,
      recipient_id: notification.recipient_id,
      type: notification.type,
      message: {
        id: rental_info[:id],
        car_id: rental_info[:car_id],
        user_id: rental_info[:user_id],
        rental_date: rental_info[:rental_date],
        return_date: rental_info[:return_date],
        created_at: rental_info[:created_at],
        updated_at: rental_info[:updated_at],
        status: rental_info[:status],
        car: {
          model: car_info.model,
          year: car_info.year,
          price: car_info.price
        }
      },
      read_at: notification.read_at,
      created_at: notification.created_at,
      updated_at: notification.updated_at
    }
  end

  def avatar_url(user)
    Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) if user.avatar.attached?
  end

  def respond_with(resource, _opts = {})
    user_data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
    user_data[:avatar_url] = avatar_url(resource)

    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: user_data
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
