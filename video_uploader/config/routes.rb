Rails.application.routes.draw do
  devise_for :admins
  root to: 'events#index'
  resources :events, only: [:index, :destroy] do
    collection do
      get '/search', to: 'events#search'
      get '/history', to: 'events#history'
    end
  end
  resources :presentations, only: [:index, :edit, :new, :create, :destroy, :update] do
    collection do
      get '/search', to: 'presentations#search'
    end
  end

  if Rails.env.development?
    get 'googleauth/start', to: 'google_auth#start'
    get 'googleauth/callback', to: 'google_auth#callback'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/screenshots', to: 'pages#screenshots'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
