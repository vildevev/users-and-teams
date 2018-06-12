# Submission:

# Here are a couple of assumptions I've made:

# 1. The user 'deleted' property has an integer value. I noticed that with all but one of the user instances have that set to the value of 0. With your daffy duck example I made the assumption that deleted values that are anything else than 0 means that the user is deleted.

# 2. That manual testing will suffice. Due to the short timeframe of the challenge I haven't had the chance to write tests for the program. I am aware that this is a vital part of writing code in a production environment and I would have done it if I had more time.

# To run the program:

# - You need ruby installed as well as the SQlite3 gem

# - Make sure the db is correctly set up following the instructions in 'instructions.md'

# - Inside the directory run the command (quotes around the input are optional):

	> ruby find_my_teams.rb "daffy_duck@qa.com"
