Rails.application.routes.draw do
  namespace :admin do
    root "application#index"
    resources :users, only: [:index]
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  devise_for :users

  #nested resources events/event_id/comments
  resources :events do 
    resources :comments, only: [:create]
  end

  resources :users, only: [:show]
  resources :categories, only: [:show]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "events#index"
end
