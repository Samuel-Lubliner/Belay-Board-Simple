Rails.application.routes.draw do
  root "availabilities#index"

  devise_for :users

  resources :availabilities do
    resources :comments, only: [:create, :destroy]
  end
  
  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
  end

  get '/dashboard', to: 'users#dashboard'
end
