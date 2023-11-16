# frozen_string_literal: true
module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      # before_action :configure_sign_in_params, only: [:create]
      respond_to :json
    end
  end
end
