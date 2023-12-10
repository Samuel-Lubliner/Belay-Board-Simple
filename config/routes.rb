Rails.application.routes.draw do
  resources :climbers
  root "availabilities#index"

  devise_for :users, controllers: { sessions: 'users/sessions' }

  get 'dashboard', to: 'users#dashboard', as: :dashboard
  
  resources :availabilities do
    resources :comments, only: [:create, :destroy]
  end

  resources :availabilities do
    get 'on_date/:date', on: :collection, action: :on_date, as: :on_date
  end

  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
  end

  resources :friend_requests, only: [:index, :create, :update, :destroy]

end
