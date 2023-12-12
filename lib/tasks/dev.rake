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
    
      10.times do
        fake_name = Faker::Name.unique.first_name
        user_names << fake_name
      end
    
      user_names.each do |name|
        user_attrs = {
          username: name,
          email: "#{name.downcase}@example.com",
          password: "password",
          is_public: name == "Sam" || name == "Julia" # Sam and Julia are public
        }
        puts "Creating user with attributes: #{user_attrs.inspect}"
    
        user = User.create!(user_attrs)
    
        # Only Sam and Julia are instructors
        is_instructor = name == "Sam" || name == "Julia"
    
        user.climber.update!(
          bio: Faker::Lorem.sentence,
          instructor: is_instructor,
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
      event_names = ["Boulder", "Top Rope", "Lead Climb", "Train", "Social Climb", "Climbing Team", "Meet up", "Birthday Party", "Fun Climb", "Climb With Me"]
      locations = ["Movement LP", "Movement Wrigley", "FA Avondale", "FA Loop", "BKB West Loop"]
    
      User.find_each do |user|
        (0...2).each do |month|
          start_date = Date.today.beginning_of_month + month.months
          end_date = start_date.end_of_month
    
          (start_date..end_date).each do |day|
            morning = day.to_time.change(hour: 6)
            evening = day.to_time.change(hour: 21)
            start_time = Faker::Time.between(from: morning, to: evening)
            end_time = start_time + [2, 3, 4].sample.hours
    
            if end_time.hour > 21 || (end_time.hour == 21 && end_time.min > 0)
              end_time = day.to_time.change(hour: 21)
            end
    
            event_name = event_names.sample
            location = locations.sample
            description = Faker::Lorem.sentence
    
            learn_flag = ["Sam", "Julia"].include?(user.username) # learn is true for Sam and Julia
    
            Availability.create!(
              event_name: event_name, 
              start_time: start_time, 
              end_time: end_time, 
              user_id: user.id,
              advanced: [true, false].sample,
              beginner: [true, false].sample,
              boulder: [true, false].sample,
              indoor: [true, false].sample,
              intermediate: [true, false].sample,
              lead: [true, false].sample,
              outdoor: [true, false].sample,
              overhang: [true, false].sample,
              slab: [true, false].sample,
              sport: [true, false].sample,
              top_rope: [true, false].sample,
              trad: [true, false].sample,
              vertical: [true, false].sample,
              learn: learn_flag,
              location: location,
              description: description
            )
          end
        end
      end
    
      puts "Availabilities added"
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
    
      selected_users = User.order("RANDOM()").limit(3)
    
      selected_users.each do |user|
        Availability.find_each do |availability|
          2.times do
            comment_body = Faker::Lorem.sentence
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
