Rails.application.routes.draw do
  devise_for :admins
  root to: 'events#index'
  resources :events, only: [:index, :destroy]
  resources :presentations, only: [:index, :edit, :new, :create, :destroy, :update]

  get 'googleauth/start', to: 'google_auth#start'
  get 'googleauth/callback', to: 'google_auth#callback'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
