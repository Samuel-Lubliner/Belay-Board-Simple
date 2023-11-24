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

  resources :event_requests, only: [:create] do
    member do
      post :accept
      post :reject
    end
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
```html
<%= month_calendar(header: {class: 'calendar-heading'}) do |date| %>
    <div class="card mb-3">
      <div class="card-header">
        <%= date.strftime("%d") %>
        <%= link_to raw('<i class="fas fa-calendar-plus"></i>'), new_availability_path(start_date: date.to_date) %>

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

## Post and delete comments on availabilities
Now that I have a calendar with availabilities, add Description and comments, I want to allow users to post and delete comments on availabilities. Comments made by the user who cerated the availability will be displayed as a description section. Comments made by guests will be displayed under the description as a comment section. 

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
      redirect_to @availability
    else
      redirect_to @availability, alert: 'Unable to add comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.availability
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

```html
<h3>Comments</h3>
    <div class="card mb-3">
      <div class="card-body">
        <% @availability.comments.each do |comment| %>
          <% unless comment.user == @availability.user %>
            <div class="d-flex justify-content-between">
              <p><strong><%= comment.user.username %>:</strong> <%= comment.body %></p>
              <% if current_user == comment.user %>
              <% end %>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>

    <%= form_for([@availability, @availability.comments.new], html: { class: "mb-3" }) do |f| %>
      <div class="form-group">
        <%= f.text_area :body, class: "form-control", rows: 3 %>
      </div>

      <% if current_user == @availability.user %>
        <div class="form-group d-flex justify-content-end">
          <%= f.button 'Description<i class="fas fa-paper-plane"></i>'.html_safe, type: :submit, class: "btn btn-primary" %>
        </div>
      <% else %>
        <div class="form-group d-flex justify-content-end">
          <%= f.button 'Comment<i class="fas fa-paper-plane"></i>'.html_safe, type: :submit, class: "btn btn-primary" %>
        </div>
      <% end %>
    <% end %>
  </div>
```

## Next Steps
Now that I have a calendar to display the index of availabilities, I will develop a calendar with filtering for availabilities where the user is a the event creator and availabilities where the user is a guest. I will also implement a dashboard for guest status.

Originally the index page showed all the availabilities. A user may want to only view availabilities that they are interested in. The calendar can be filtered by a combination of particular hosts and guests. Futhermore, the calendar can be searched by event title names.

## Calendar Filtering for Hosts Users and search by event name
```rb
class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i[ show edit update destroy ]

  # GET /availabilities or /availabilities.json
  def index
    @selected_host_id = params[:host_id]
    @selected_guest_id = params[:guest_id]
    @event_name_query = params[:event_name]

    @availabilities = Availability.all

    if @selected_host_id.present?
      @availabilities = @availabilities.where(user_id: @selected_host_id)
    end

    if @selected_guest_id.present?
      guest_availabilities = EventRequest.where(user_id: @selected_guest_id, status: 'accepted').pluck(:availability_id)
      @availabilities = @availabilities.where(id: guest_availabilities)
    end

    if @event_name_query.present?
      @availabilities = @availabilities.where('event_name ILIKE ?', "%#{@event_name_query}%")
    end
  end
```

## Collapsible search form.

```html
<div style="text-align: center;">

    <h1>Climb Times</h1>

    <%= link_to '#', class: 'btn btn-primary', data: { bs_toggle: 'collapse', bs_target: '#filterForm' } do %>
      <i class="fas fa-search"></i>
    <% end %>

    <div id="filterForm" class="collapse">
      <%= form_with(url: availabilities_path, method: :get, local: true) do |form| %>
  <div class="form-group">
    <%= form.label :host_id, "Host" %>
    <%= form.collection_select :host_id, [['All Hosts', nil]] + User.all.map { |u| [u.username, u.id] }, :last, :first, 
        selected: @selected_host_id, include_blank: false, class: 'form-control' %>
  </div>

  <div class="form-group">
    <%= form.label :guest_id, "Guest" %>
    <%= form.collection_select :guest_id, [['All Guests', nil]] + User.all.map { |u| [u.username, u.id] }, :last, :first, 
        selected: @selected_guest_id, include_blank: false, class: 'form-control' %>
  </div>

        <div class="row justify-content-center">
          <div class="col-md-2">
            <div class="form-group">

              <%= form.text_field :event_name, value: @event_name_query, 
            class: 'form-control', placeholder: ' Search Event Names' %>
            </div>
          </div>
        </div>
        <%= form.submit "Filter", class: 'btn btn-success' %>
      <% end %>
    </div>
  </div>
```

## Add Dashboard 
A user needs a way to view availabilities ordered by start time. A user may want to search availabilities by status. Originally i named the status :accepted, :rejected, :pending and this is how the event creator views them. I thought it would be a nice touch if the event guests viewed more friendly statuses like Confirmed, Canceled, and Pending. Furthermore, a guest can filter requests by a range of start and end times as well as search by event names.    

### Routes

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

### Dashboard action in controller 
```rb
class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @event_requests = current_user.event_requests.includes(:availability)
  
    if params[:status].present?
      @event_requests = @event_requests.where(status: params[:status])
    end
  
    if params[:event_name].present?
      @event_requests = @event_requests.joins(:availability).where('availabilities.event_name ILIKE ?', "%#{params[:event_name]}%")
    end
  
    if params[:start_time].present? && params[:end_time].present?
      start_time = Date.parse(params[:start_time])
      end_time = Date.parse(params[:end_time])
      @event_requests = @event_requests.joins(:availability).where('availabilities.start_time >= ? AND availabilities.end_time <= ?', start_time, end_time)
    end

    @event_requests = @event_requests.joins(:availability).order('availabilities.start_time ASC')
  end
end
```

```html
<div class="container">

<h2>Event Requests</h2>

<%= form_tag dashboard_path, method: :get, class: "row g-3" do %>
  <div class="col-md-3">
    <%= label_tag :start_time, "Start Time", class: 'form-label' %>
    <%= date_field_tag :start_time, params[:start_time], class: 'form-control' %>
  </div>

  <div class="col-md-3">
    <%= label_tag :end_time, "End Time", class: 'form-label' %>
    <%= date_field_tag :end_time, params[:end_time], class: 'form-control' %>
  </div>

 <div class="col-md-3">
  <%= label_tag :status, "Status", class: 'form-label' %>
  <%= select_tag :status, 
      options_for_select(
        {
          'Any' => '',
          'Pending' => 'pending',
          'Confirmed' => 'accepted',
          'Canceled' => 'rejected'
        }, 
        params[:status]
      ), 
      class: 'form-select' 
  %>
</div>

  <div class="col-md-3">
    <%= label_tag :event_name, "Event Name", class: 'form-label' %>
    <%= text_field_tag :event_name, params[:event_name], class: 'form-control', placeholder: 'Search Event Names' %>
  </div>

  <div class="col-12">
    <%= submit_tag "Filter", class: 'btn btn-primary' %>
  </div>
<% end %>

<table class="table">
  <thead>
    <tr>
      <th scope="col">Event Name</th>
      <th scope="col">Start Time</th>
      <th scope="col">End Time</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <% @event_requests.each do |request| %>
      <tr>
        <td><%= link_to request.availability.event_name, availability_path(request.availability) %></td>
        <td><%= request.availability.start_time.strftime('%b %d, %Y %I:%M %p') %></td>
        <td><%= request.availability.end_time.strftime('%b %d, %Y %I:%M %p') %></td>
        <td>
          <% case request.status %>
          <% when 'accepted' %>
            Confirmed
          <% when 'rejected' %>
            Canceled
          <% else %>
            <%= request.status.capitalize %>
          <% end %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
</div>
```
