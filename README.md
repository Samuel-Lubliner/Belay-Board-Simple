# Belay Board
Hello, my name is Sam Lubliner. I am a full stack software developer apprentice. I drew on my experience as a coach in the climbing industry to create a web application for scheduling climbing sessions and finding climbing partners.

## Run locally  
Run `rake dev:reset` to reset the database and generate sample data with users, availabilities, event_requests, comments, and friend_requests.

Run `Bin/dev` to start up the development environment and server. 

Stop the server before rerunning `rake dev:reset`

Users: Sam, Ben, Olivia, Rashid, Robbie, Julia, plus 10 FAKER users

login with: 
Email: {lowercase username}@example.com
Password: password 

Log in as Sam or Ben to respond to event requests or make requests.

Users other than sam and ben have already made event requests.

Feel free to sign up and create new users. 











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
