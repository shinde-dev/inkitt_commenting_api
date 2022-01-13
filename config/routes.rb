# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[show] do
        resources :comments, only: %i[create update index] do
          resources :replies, only: %i[index]
        end
      end
    end
  end
end
