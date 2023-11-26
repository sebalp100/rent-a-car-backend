# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix

  respond_to :json

  private

  def avatar_url(user)
    Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) if user.avatar.attached?
  end

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      user_data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
      user_data[:avatar_url] = avatar_url(resource)

      render json: {
        status: { code: 200, message: "Signed up successfully." },
        data: user_data
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
