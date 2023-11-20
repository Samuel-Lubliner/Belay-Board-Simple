# Belay Board

## Adding postgresql with citext 
```yml

default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: belay_board_development

test:
  <<: *default
  database: belay_board_test

production:
  <<: *default
  database: belay_board_production
  username: belay_board
  password: <%= ENV["BELAY_BOARD_DATABASE_PASSWORD"] %>
```
`rails generate migration enable_citext_extension`

```rb
class EnableCitextExtension < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'
  end
end
```

`rails rb:migrate`

## Add Users with devise
`rails generate devise:install`
`rails generate devise User username:citext`

### User views
`rails generate devise:views`

## devise parameters

```rb
class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
```

## Add Availabilities
`rails g scaffold Availability event_name:string start_time:datetime end_time:datetime user:references`

### Update models

## Add EventRequest
`rails g model EventRequest user:references availability:references status:string`

### Update models

### Set up controller to set availability creator as the host

## Allow a user to join an Availability and accept or reject guests

```ruby
class EventRequest < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }

  validates :user_id, uniqueness: { scope: :availability_id }

  def accept
    update(status: 'accepted')
  end

  def reject
    update(status: 'rejected')
  end

end
```

`rails generate controller EventRequests`

```rb
cclass EventRequestsController < ApplicationController
  before_action :set_event_request, only: %i[show edit update destroy]

  def create
    @event_request = current_user.event_requests.new(event_request_params)

    if @event_request.save
      # Handle success (e.g., redirect with a success message)
    else
      # Handle failure (e.g., render form again with error messages)
    end
  end

  def accept
    event_request = EventRequest.find(params[:id])
    if event_request.availability.user == current_user
      event_request.accept
      # Success message and redirect
    else
      # Error message and redirect
    end
  end
  
  def reject
    event_request = EventRequest.find(params[:id])
    if event_request.availability.user == current_user
      event_request.reject
      # Success message and redirect
    else
      # Error message and redirect
    end
  end

  private

  def event_request_params
    params.require(:event_request).permit(:availability_id)
    # Do not include :user_id, it's set automatically to current_user
  end
  
end

```

```html
<% if current_user && @availability.user != current_user %>
  <%= form_for(current_user.event_requests.new, url: event_requests_path) do |f| %>
    <%= f.hidden_field :availability_id, value: @availability.id %>
    <%= f.submit "Join this Event" %>
  <% end %>
<% end %>
```

### Add route
```rb
Rails.application.routes.draw do
  root "availabilities#index" # Or another controller#action as your homepage
  
  devise_for :users

  resources :availabilities

  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
  end
```
