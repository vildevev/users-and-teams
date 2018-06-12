require 'sqlite3'

def in_query_parametization(ids)
  # Function for formatting an sql 'in' condition
  query_str = '('
  if ids.is_a? Hash 
    arr = ids.map { |k, v| k } 
  else 
    arr = ids.map { |obj| obj[0] } 
  end 
  query_str.concat(arr.join(', ') + ')')
end

def find_current_teams(db, user_input_email, teams_member_in)
  # Find all the teams that the given email is a member of, excluding the deleted
  db.execute("SELECT teams.id, teams.name FROM teams JOIN users ON teams.id=users.team_id WHERE email='#{user_input_email}' AND deleted=0") do |team_obj|
    teams_member_in << team_obj
  end
  teams_member_in
end

def find_possible_teams(db, user_email_domain, teams_member_in_str, possible_teams)
  # Find all the teams that the user is not currently a member of and have the correct email domain
  db.execute("SELECT id, name FROM teams WHERE email_domain='#{user_email_domain}' AND id NOT IN #{teams_member_in_str}") do |team_obj|
    possible_teams[team_obj[0]] = team_obj
  end
  possible_teams
end

def find_teams_with_members(db, possible_teams_str, teams_with_members, possible_teams)
  # Clone hash in order to not alter
  possible_teams_clone = possible_teams.clone
  # Find how many members the possible teams have, sort them in descending order
  db.execute("SELECT team_id, COUNT(*) AS NUM_OF_USERS_IN_GROUP FROM users WHERE team_id IN #{possible_teams_str} GROUP BY team_id ORDER BY NUM_OF_USERS_IN_GROUP DESC") do |team_obj|
    # Delete teams that are added to array
    possible_teams_clone.delete(team_obj[0])
    teams_with_members << team_obj
  end
  # Add the teams that have no members
  possible_teams_clone.each do |k,v|
    teams_with_members << [k, 0]
  end
  teams_with_members
end

def print_team_info(teams_member_in, teams_with_members, possible_teams)
  # Print the results to the user
  print "✨ You are a member of: \n"
  teams_member_in.each do |team_obj|
	 print "#{team_obj[1]} (#{team_obj[0]}) \n\n"
  end

  print "✨ You are eligible to join: \n"
  teams_with_members.each do |team_obj|
	 team_info = possible_teams[team_obj[0]]
	 print "#{team_info[1]} (#{team_info[0]})         #{team_obj[1]} members\n"
  end
end 

def run_file()
  teams_member_in = []
  possible_teams = {}
  teams_with_members = []
  user_input_email = ARGV[0].to_s
  user_email_domain = user_input_email.split('@')[1]
  return print "You need to provide a valid email" if user_email_domain == nil
  db = SQLite3::Database.open("appeng_take_home_db")
  current_teams = find_current_teams(db, user_input_email, teams_member_in)
  teams_member_in_str = in_query_parametization(teams_member_in)
  possible_teams = find_possible_teams(db, user_email_domain, teams_member_in_str, possible_teams)
  possible_teams_str = in_query_parametization(possible_teams)
  teams_with_members = find_teams_with_members(db, possible_teams_str, teams_with_members, possible_teams)
  db.close
  print_team_info(teams_member_in, teams_with_members, possible_teams)
end 

run_file
