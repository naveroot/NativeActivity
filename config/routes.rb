Rails.application.routes.draw do
  root to: 'cities#index'

  resources :cities
  resources :activities

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
