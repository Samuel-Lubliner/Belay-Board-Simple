if Rails.env.development?
  namespace :dev do
    desc "Drops, creates, migrates, and adds sample data to database"
    task reset: [:environment, "db:drop", "db:create", "db:migrate", "dev:sample_data"]

    desc "Adds sample data for development environment"
    task sample_data: [:environment, "dev:add_users", "dev:add_availabilities"] do
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
        6.times do |month|
          15.times do
            start_date = Date.today.beginning_of_month + month.months
            end_date = Date.today.end_of_month + month.months
            start_time = Faker::Time.between_dates(from: start_date, to: end_date, period: :day)
            end_time = start_time + [2, 3, 4, 5].sample.hours
            event_name = event_names.sample
            Availability.create!(event_name: event_name, start_time: start_time, end_time: end_time, user_id: user.id)
          end
        end
      end
    end
  end
end
