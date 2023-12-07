# frozen_string_literal: true

Rails.application.routes.draw do
  resources :brands
  resources :rentals
  resources :cars
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }
  devise_scope :user do
    namespace :users do
      resource :sessions, only: [] do
        member do
          get 'notifications'
        end
      end
    end
  end
end
