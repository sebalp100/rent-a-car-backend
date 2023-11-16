# frozen_string_literal: true
module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]
      respond_to :json
    end
  end
end
