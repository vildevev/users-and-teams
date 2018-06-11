require 'sqlite3'

# The user input:
user_input_email = ARGV[0].to_s
user_email_domain = user_input_email.split('@')[-1]

# Variables for the print statements, defined here so we have access not just in the function scope
teams_member_in = []
possible_teams = []
teams_with_members = []

# Function for formatting an sql 'in' condition
def in_query_parametization(ids)
  query_str = '('
  if ids.is_a? Hash 
    arr = ids.map { |k, v| k } 
  else 
    arr = ids.map { |obj| obj[0] } 
  end 
  query_str.concat(arr.join(',') + ')')
end 

# Open up the db file
SQLite3::Database.open("appeng_take_home_db") do |db|
	# Find all the teams that the given email is a member of, excluding the deleted
  db.execute("SELECT teams.id, teams.name FROM teams JOIN users ON teams.id=users.team_id WHERE email=? and deleted=0;", [user_input_email] ) do |team_obj|
  	teams_member_in << team_obj
  end 
  teams_member_in_str = in_query_parametization(teams_member_in)
  # Find all the teams that the user is not currently a member of and have the correct email domain
  db.execute("SELECT id, name FROM teams WHERE email_domain=? AND id NOT IN #{teams_member_in_str};", [user_email_domain] ) do |team_obj|
  	possible_teams[team_obj[0]] = team_obj
  end
  current_teams_str = in_query_parametization(possible_teams)
  # Find how many members the possible teams have, sort them in descending order
  db.execute("SELECT team_id, COUNT(*) AS NUM_OF_USERS_IN_GROUP FROM users WHERE team_id IN #{current_teams_str} GROUP BY team_id ORDER BY NUM_OF_USERS_IN_GROUP DESC") do |team_w_count|
  	teams_with_members << team_w_count
  end 
end

# Print the results to the user:
print "You are a member of: \n"
teams_member_in.each do |team_obj|
	print "#{team_obj[1]} (#{team_obj[0]}) \n"
end

print "You are eligible to join: \n"
teams_with_members.each do |team_obj|
	team_info = possible_teams[team_obj[0]]
	print "#{team_info[1]} (#{team_info[0]})         #{team_obj[1]} members\n"
end
