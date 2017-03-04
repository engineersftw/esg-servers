Rails.application.routes.draw do
  root to: 'presentations#index'
  resources :presentations, only: [:index, :create]

  get 'googleauth/start', to: 'google_auth#start'
  get 'googleauth/callback', to: 'google_auth#callback'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
