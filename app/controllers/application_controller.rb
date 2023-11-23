# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end
end
