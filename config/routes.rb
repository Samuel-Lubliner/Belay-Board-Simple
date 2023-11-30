Rails.application.routes.draw do
  resources :climbers
  root "availabilities#index"

  devise_for :users

  get 'dashboard', to: 'users#dashboard', as: :dashboard
  
  resources :availabilities do
    resources :comments, only: [:create, :destroy]
  end
  
  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
  end
end
