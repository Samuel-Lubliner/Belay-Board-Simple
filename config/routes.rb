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





  # resources :availabilities
  # devise_for :users

  # resources :event_requests, only: [:create]

  # resources :event_requests do
  #   member do
  #     put :accept
  #     put :reject
  #   end
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
