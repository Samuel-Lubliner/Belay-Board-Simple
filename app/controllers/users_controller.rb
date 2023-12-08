class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard

    @availability_category_data = calculate_availability_categories

    @climbing_time_data = calculate_climbing_time

    @climbing_partners_data = calculate_climbing_partners

  end

  private

  def calculate_availability_categories
    user_availabilities = Availability.where(user_id: current_user.id)
  
    friend_ids = FriendRequest.where(receiver_id: current_user.id, status: 'accepted').pluck(:sender_id) +
                 FriendRequest.where(sender_id: current_user.id, status: 'accepted').pluck(:receiver_id)
    friend_availabilities = Availability.where(user_id: friend_ids)
  
    # Fetch availabilities where the current user is accepted in event requests
    accepted_event_availabilities = EventRequest.where(user_id: current_user.id, status: 'accepted')
                                                .includes(:availability)
                                                .map(&:availability)
  
    # Combine all relevant availabilities
    all_relevant_availabilities = (user_availabilities + friend_availabilities + accepted_event_availabilities).uniq
  
    categories = %w[boulder lead top_rope]
    categories.each_with_object({}) do |category, data|
      data[category.capitalize] = all_relevant_availabilities.count { |availability| availability[category] }
    end
  end
  
  

  def calculate_climbing_time
    user_availabilities = Availability.where(user_id: current_user.id)
    accepted_event_requests = EventRequest.where(user_id: current_user.id, status: 'accepted')
                                          .includes(:availability)
                                          .map(&:availability)
  
    all_relevant_availabilities = (user_availabilities + accepted_event_requests).uniq
  
    # Determine the date range from availabilities
    earliest_date = Availability.minimum(:start_time).to_date
    latest_date = Availability.maximum(:end_time).to_date
    date_range = (earliest_date..latest_date).to_a
  
    # Initialize climbing time data for each date in the range
    climbing_time_data = date_range.each_with_object({}) { |date, data| data[date] = 0 }
  
    # Aggregate climbing time
    all_relevant_availabilities.each do |availability|
      date = availability.start_time.to_date
      if climbing_time_data.key?(date)
        duration = availability.end_time - availability.start_time
        climbing_time_data[date] += duration
      end
    end
  
    climbing_time_data.transform_values { |seconds| seconds / 3600.0 } # Convert seconds to hours
  end
  

  def calculate_climbing_partners
    # Total time for availabilities created by the current user
    user_availabilities_with_others = EventRequest.where(availability_id: Availability.where(user_id: current_user.id).select(:id), status: 'accepted')
                                                   .joins(:availability)
                                                   .group(:user_id)
                                                   .sum('EXTRACT(EPOCH FROM (availabilities.end_time - availabilities.start_time))')
  
    # Total time for availabilities where the current user is accepted
    availabilities_with_current_user = EventRequest.joins(:availability)
                                                   .where(user_id: current_user.id, status: 'accepted')
                                                   .group('availabilities.user_id')
                                                   .sum('EXTRACT(EPOCH FROM (availabilities.end_time - availabilities.start_time))')
  
    # Combine the total times, summing up the durations
    combined_data = user_availabilities_with_others.merge(availabilities_with_current_user) { |key, a, b| a + b }
  
    # Transform user IDs to usernames and convert seconds to hours
    combined_data.transform_keys { |user_id| User.find(user_id).username }
                 .transform_values { |seconds| seconds / 3600.0 } # Convert seconds to hours
  end
  
end
