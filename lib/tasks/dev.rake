if Rails.env.development?


  namespace :dev do
    desc "Drops, creates, migrates, and adds sample data to database"
    task reset: [:environment, "db:drop", "db:create", "db:migrate", "dev:sample_data"]

    desc "Adds sample data for development environment"
    task sample_data: [:environment, "dev:add_users", "dev:add_availabilities", "dev:add_event_requests", "dev:add_comments"] do
      puts "Done adding sample data"
    end

    task add_users: :environment do
      puts "Adding users..."
      ["Sam", "Ben", "Olivia", "Rashid", "Robbie", "Julia"].each do |name|
        user_attrs = {username: name.downcase, email: "#{name.downcase}@example.com", password: "password"}
        puts "Creating user with attributes: #{user_attrs.inspect}"
        User.create!(user_attrs)
      end
    end

    task add_availabilities: :environment do
      puts "Adding availabilities..."
      event_names = ["Boulder", "Top Rope", "Lead Climb", "Train"]
      User.find_each do |user|
        # Loop through the next 4 months
        (0...4).each do |month|
          # Calculate the start and end date of each month
          start_date = Date.today.beginning_of_month + month.months
          end_date = start_date.end_of_month
    
          # Loop through each day of the month
          (start_date..end_date).each do |day|
            # Generate start and end times for the event
            start_time = Faker::Time.between_dates(from: day, to: day, period: :day)
            end_time = start_time + [2, 3, 4, 5].sample.hours
    
            # Select a random event name
            event_name = event_names.sample
    
            # Create the availability
            Availability.create!(event_name: event_name, start_time: start_time, end_time: end_time, user_id: user.id)
          end
        end
      end
    end

    task add_event_requests: :environment do
      puts "Adding event requests..."
    
      # Find users Sam and Ben
      sam = User.find_by(username: 'sam')
      ben = User.find_by(username: 'ben')
    
      User.where.not(id: [sam.id, ben.id]).find_each do |user|
        events = Availability.where.not(user_id: user.id).sample(100000)
        events.each do |event|
          status = [sam.id, ben.id].include?(event.user_id) ? 'pending' : %w[pending accepted rejected].sample
          EventRequest.create!(user: user, availability: event, status: status)
        end
      end
    
      puts "Event requests added"
    end

    task add_comments: :environment do
      puts "Adding comments..."
  
      User.find_each do |user|
        Availability.find_each do |availability|
          2.times do
            comment_body = Faker::TvShows::Simpsons.quote
            Comment.create!(user: user, availability: availability, body: comment_body)
          end
        end
      end
  end

    puts "Comments added"
  end

end
