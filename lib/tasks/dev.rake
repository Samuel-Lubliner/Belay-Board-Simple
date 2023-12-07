if Rails.env.development?


  namespace :dev do
    desc "Drops, creates, migrates, and adds sample data to database"
    task reset: [:environment, "db:drop", "db:create", "db:migrate", "dev:sample_data"]

    desc "Adds sample data for development environment"
    task sample_data: [:environment, "dev:add_users", "dev:add_availabilities", "dev:add_event_requests", "dev:add_comments", "dev:add_friend_requests"] do
      puts "Done adding sample data"
    end

    task add_users: :environment do
      puts "Adding users..."
    
      user_names = ["Sam", "Ben", "Olivia", "Rashid", "Robbie", "Julia"]
    
      15.times do
        fake_name = Faker::Name.unique.first_name
        user_names << fake_name
      end
    
      user_names.each do |name|
        user_attrs = {
          username: name.downcase,
          email: "#{name.downcase}@example.com",
          password: "password",
          is_public: [true, false].sample # Randomly assign is_public
        }
        puts "Creating user with attributes: #{user_attrs.inspect}"
    
        user = User.create!(user_attrs)
    
        user.climber.update!(
          bio: Faker::Quote.famous_last_words,
          instructor: [true, false].sample,
          boulder: [true, false].sample,
          top_rope: [true, false].sample,
          lead: [true, false].sample,
          vertical: [true, false].sample,
          slab: [true, false].sample,
          overhang: [true, false].sample,
          beginner: [true, false].sample,
          intermediate: [true, false].sample,
          advanced: [true, false].sample,
          sport: [true, false].sample,
          trad: [true, false].sample,
          indoor: [true, false].sample,
          outdoor: [true, false].sample
        )
    
        puts "User and climber profile created for #{name}"
      end
    
      puts "All users added"
    end
    
    task add_availabilities: :environment do
      puts "Adding availabilities..."
      event_names = ["Boulder", "Top Rope", "Lead Climb", "Train"]
      User.find_each do |user|
        (0...2).each do |month|
          start_date = Date.today.beginning_of_month + month.months
          end_date = start_date.end_of_month
    
          (start_date..end_date).each do |day|
            start_time = Faker::Time.between_dates(from: day, to: day, period: :day)
            end_time = start_time + [2, 3, 4].sample.hours
    
            event_name = event_names.sample
    
            Availability.create!(event_name: event_name, start_time: start_time, end_time: end_time, user_id: user.id)
          end
        end
      end
    end

    task add_event_requests: :environment do
      puts "Adding event requests..."
    
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
            comment_body = Faker::GreekPhilosophers.quote
            Comment.create!(user: user, availability: availability, body: comment_body)
          end
        end
      end


    puts "Comments added"
  end

  task add_friend_requests: :environment do
    puts "Adding friend requests..."
  
    User.where(is_public: false).find_each do |private_user|
      # Select random users to send friend requests to the private user
      senders = User.where.not(id: private_user.id).order("RANDOM()").limit(5)
  
      senders.each do |sender|
        FriendRequest.create!(
          sender: sender,
          receiver: private_user,
          status: 'pending' # Default status is 'pending'
        )
        puts "Friend request sent from #{sender.username} to #{private_user.username}"
      end
    end
  
    puts "Friend requests added"
  end

  
  
end
end
