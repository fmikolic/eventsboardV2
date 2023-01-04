Rails.application.routes.draw do
  namespace :admin do
    root "application#index"
  end
  devise_for :users
  resources :events
  resources :users, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"
end
