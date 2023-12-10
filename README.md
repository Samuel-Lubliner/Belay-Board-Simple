# Belay Board
Hello, my name is Sam Lubliner. I am a full stack software developer apprentice. I drew on my experience as a coach in the climbing industry to create a web application for scheduling climbing sessions and finding climbing partners.

## Pain points 
I want to climb, however I need to find a partner and coordinate availabilities.

If I go to the gym by myself, finding a climbing partner is challenging because there are so many different styles and preferences.

## Solution 
Find climbing partners and schedule climbing sessions with Belay Board!

### User Stories 
- Create a private or public account. Write a bio.
- Select climbing preferences:
  - Skill Level: 
    - Beginner
    - Intermediate
    - Advanced
    - Instructor

  - Climbing Type:
    - Boulder
    - Top rope
    - Lead

  - Angle:
    - Vertical
    - Slab
    - Overhang

  - Climbing Style:
    - Sport
    - Trad
    - Indoor
    - Outdoor

- Search for and filter climber community profiles.
  - Send friend requests to view private profiles.

- Post an availability on the Belay Board Calendar
  - Enter a event name, description, time, location, and session preferences.

- View posted climbing sessions
  - Request to join session
  - Post comments

- View dashboard
  - Column chart:
    - Climbing hours per day
  - Pie charts:
    - Distribution of climbing session hours among partners
    - Distribution of climbs by boulder, lead, or top rope

In progress:

- Opt in to emails
  - Summary of events for the next day
  - When someone accepts event request



## Email
https://guides.rubyonrails.org/action_mailer_basics.html

### set up development
  ```rb
  # config/environments/development.rb
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
```


### Add Confirmable
```rb
class AddConfirmableToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table(:users) do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end
  end
end
```

### Install Gem for development emails
https://github.com/ryanb/letter_opener
```rb
group :development do
  gem "letter_opener", "~> 1.8"
```

### Customize Devise
`Rails generate devise:views`

### Customize my own emails 
`Rails g mailer`

```bash
Usage:
  rails generate mailer NAME [method method] [options]

Options:
      [--skip-namespace], [--no-skip-namespace]              # Skip namespace (affects only isolated engines)
      [--skip-collision-check], [--no-skip-collision-check]  # Skip collision check
  -e, [--template-engine=NAME]                               # Template engine to be invoked
                                                             # Default: erb
  -t, [--test-framework=NAME]                                # Test framework to be invoked

Runtime options:
  -f, [--force]                    # Overwrite files that already exist
  -p, [--pretend], [--no-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet]      # Suppress status output
  -s, [--skip], [--no-skip]        # Skip files that already exist

Description:
============
    Generates a new mailer and its views. Passes the mailer name, either
    CamelCased or under_scored, and an optional list of emails as arguments.

    This generates a mailer class in app/mailers and invokes your template
    engine and test framework generators.

Example:
========
    bin/rails generate mailer Notifications signup forgot_password invoice

    creates a Notifications mailer class, views, and test:
        Mailer:     app/mailers/notifications_mailer.rb
        Views:      app/views/notifications_mailer/signup.text.erb [...]
        Test:       test/mailers/notifications_mailer_test.rb 
```

Run 
`rails g mailer User summary`

```bash
      create  app/mailers/user_mailer.rb
      invoke  erb
      create    app/views/user_mailer
      create    app/views/user_mailer/summary.text.erb
      create    app/views/user_mailer/summary.html.erb
```

### Previews 
```rb
#test/mailers/previews/user_mailer_preview.rb

class UserMailerPreview < ActionMailer::Preview
  def summary
    UserMailer.with(user: User.first).summary
  end
end
```

```rb
# config/environments/development.rb

config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"
```

In the browser navigate to `http://127.0.0.1:3000/rails/mailers`
