Rails.application.routes.draw do
  resources :availabilities
  devise_for :users
  resources :event_requests, only: [:create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
