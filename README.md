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
  root "availabilities#index"
  
  devise_for :users

  resources :availabilities

  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
  end
```

## Add ujs and jquery
At the bash prompt I ran these two commands to modify config/importmap.rb:

`./bin/importmap pin @rails/ujs`

`./bin/importmap pin jquery`

Then in app/javascripts/application.js, I added these lines:

```js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import Rails from "@rails/ujs"
Rails.start();
```

## Add AJAX to the join, accept and reject buttons

views/availabilities/show.html.erb
```html
<p style="color: green"><%= notice %></p>

<%= render @availability %>

<div>
  <%= link_to "Edit this availability", edit_availability_path(@availability) %> |
  <%= link_to "Back to availabilities", availabilities_path %>

  <%= button_to "Destroy this availability", @availability, method: :delete %>
</div>


<% if current_user && @availability.user != current_user %>
  <% unless @availability.event_requests.exists?(user: current_user) %>
    <%= form_for(current_user.event_requests.new, url: event_requests_path, remote: true) do |f| %>
      <%= f.hidden_field :availability_id, value: @availability.id %>
      <%= f.submit "Join this Event", id: "join-event-button" %>
    <% end %>
  <% end %>
<% end %>


<h3>Guests</h3>
<ul id="guest_requests_list" style="list-style-type: none;">
  <% @event_requests.each do |event_request| %>
    <li id="event_request_<%= event_request.id %>">
      <%= render partial: 'event_request', locals: { event_request: event_request } %>
      <% if event_request.status == 'pending' && @availability.user == current_user %>
        <%= button_to 'Accept', accept_event_request_path(event_request), method: :post, remote: true, class: 'accept-button', data: { turbo: false } %>
        <%= button_to 'Reject', reject_event_request_path(event_request), method: :post, remote: true, class: 'reject-button', data: { turbo: false } %>
      <% end %>
    </li>
  <% end %>
</ul>
```

views/event_requests/create.js.erb
```js
<% if @event_request.persisted? %>
  $("#guest_requests_list").append("<%= j(render partial: 'availabilities/event_request', locals: { event_request: @event_request }) %>");
  $("#join-event-button").fadeOut();
<% end %>
```

views/event_requests/accept.js.erb
```js
$("#event_request_<%= @event_request.id %>").html("<%= j(render partial: 'availabilities/event_request', locals: { event_request: @event_request }) %>");
```

```rb
# == Schema Information
#
# Table name: event_requests
#
#  id              :bigint           not null, primary key
#  status          :string           default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  availability_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_event_requests_on_availability_id  (availability_id)
#  index_event_requests_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (availability_id => availabilities.id)
#  fk_rails_...  (user_id => users.id)
#
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

```rb
class EventRequestsController < ApplicationController
  before_action :set_event_request, only: %i[show edit update destroy]

  def create
    @event_request = current_user.event_requests.new(event_request_params)

    respond_to do |format|
      if @event_request.save
        format.html { redirect_to @event_request.availability, notice: 'Request submitted.' }
        format.js
      else
        format.html { render 'availabilities/show', status: :unprocessable_entity }
        format.js
      end
    end
  end

  def accept
    @event_request = EventRequest.find(params[:id])
    if @event_request.availability.user == current_user
      @event_request.update(status: 'accepted')
  
      respond_to do |format|
        format.html { redirect_to availability_path(@event_request.availability), notice: 'Request accepted.' }
        format.js
      end
    end
  end
  
  def reject
    @event_request = EventRequest.find(params[:id])
    if @event_request.availability.user == current_user
      @event_request.update(status: 'rejected')
  
      respond_to do |format|
        format.html { redirect_to availability_path(@event_request.availability), notice: 'Request rejected.' }
        format.js
      end
    end
  end
  
  private
  
  def event_request_params
    params.require(:event_request).permit(:availability_id)
    # Do not include :user_id
  end
  
end
```

## Add Calendar
Add into Gemfile followed by a bundle install:
`gem "simple_calendar", "~> 2.4"`


### Calendar for availability index 
```rb
<h1>Climb Times</h1>

<%= month_calendar do |date| %>
  <div class="card mb-3">
    <div class="card-header">
      <%= date.strftime("%m / %d / %y") %>
      <%= link_to "Create!", new_availability_path(start_date: date.to_date) %>
    </div>
    <div class="card-body">
      <% day_availabilities = @availabilities.select { |a| a.start_time.to_date == date }.sort_by(&:start_time) %>
      <% day_availabilities.each do |availability| %>
        <p class="mb-1">
          <%= link_to availability.event_name, availability_path(availability), class: "text-dark" %>
          <small class="text-muted"><%= availability.start_time.strftime("%I:%M %p") %></small>
        </p>
      <% end %>
    </div>
  </div>
<% end %>
```

When creating new availability from the calendar, the start date of the availability should be set to the date corresponding to the date on the calendar.

controllers/availabilities_controller.rb
```rb
  def new
    @availability = Availability.new
    @availability.start_time = params[:start_date] if params[:start_date].present?
  end
```

views/availabilities/_form.html.erb
```html
<div>
    <%= form.label :start_time, style: "display: block" %>
    <%= form.datetime_field :start_time, value: availability.start_time&.strftime("%Y-%m-%dT%H:%M") %>
  </div>

  <div>
    <%= form.label :end_time, style: "display: block" %>
    <%= form.datetime_field :end_time, value: availability.start_time&.strftime("%Y-%m-%dT%H:%M") %>
  </div>
```

## Now that I have a calendar with availabilities, add Description and comments

I want to allow users to post and delete comments on availabilities. Comments made by the user who cerated the availability will be displayed as a description section. Comments made by guests will be displayed under the description as a comment section. 

`rails g model Comment body:text user:references availability:references`
`rails db:migrate`

### Associations

```rb
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates :body, presence: true
end

class Availability < ApplicationRecord
  #...
  has_many :comments, dependent: :destroy
end

class User < ApplicationRecord
  #...
  has_many :comments, dependent: :destroy
end
```

`rails g controller Comments`

```rb
class CommentsController < ApplicationController
  before_action :set_availability, only: [:create]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @availability.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @availability, notice: 'Comment was successfully added.'
    else
      redirect_to @availability, alert: 'Unable to add comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.availability, notice: 'Comment was successfully deleted.'
  end

  private

  def set_availability
    @availability = Availability.find(params[:availability_id])
  end
  

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :availability_id)
  end
end
```



## Different types of calendars: 
- Index of all users
- Availabilities created by user
- Availability where user is a guest


## Comments page
