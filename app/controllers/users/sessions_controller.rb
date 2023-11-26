# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix

  respond_to :json

  private

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
