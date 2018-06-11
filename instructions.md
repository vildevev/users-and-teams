# Slack Take Home Exercise

## Prompt

You forgot which Slack teams you’re eligible for! Your task is to implement a command-line program that will take an email address and return two things:


1. Which teams is that email address already a member of?
2. Which teams is that email address eligible to join? We want these to printed in sorted order from teams with the most number of users to teams with the least number of users.

What does **eligible** mean? Teams can decide that anyone with an email address that ends in a specific domain is able to join. For example, say the Midtown Academic Decathlon Team allows anyone with a `midtownscience.edu` email address to join. That means that Peter Parker will see the decathlon team in his list of eligible teams if he supplies his `@midtownscience.edu` email.

Feel free to format the output however you’d like, just make sure that for each team, we see the id, the name, and in the case of eligible teams, the number of users on that team. Here’s an example:


		> php find_my_teams.php -e "peter.parker@midtownscience.edu"

		✨ You are a member of:
		Avengers (1092819)
		Midtown Science (2837302)

		✨ You are eligible to join:
		Stark Internships (23840391)                               1,243 members
		Midtown Academic Decathlon Team (38750400)                 9 members

​​We expect this exercise to take less than three hours. Please send it back to us within three business days. If you need additional time, please contact the recruiter.

## Setting Up

We’ve provided you with three files:

- `appeng_onsite_db`
- `teams.sql`, and
- `users.sql`

You can set-up a local `sqlite3` instance by navigating to the root directory of your project and executing the following commands:


		> sqlite3
		sqlite> .open appeng_take_home_db
		sqlite> .read teams.sql
		sqlite> .read users.sql

You can take a look at the structure of some of the data provided by executing a `.schema` command.


		sqlite> .schema users
		CREATE TABLE users(
			 id       INTEGER  NOT NULL PRIMARY KEY
			,team_id  INTEGER  NOT NULL
			,email    VARCHAR(32) NOT NULL
			,username VARCHAR(18) NOT NULL
			,deleted  INTEGER  NOT NULL
		);
		sqlite> .schema teams
		CREATE TABLE teams(
			 id            INTEGER  NOT NULL PRIMARY KEY
			,name          VARCHAR(21) NOT NULL
			,email_domain  VARCHAR(100)
			,date_create   INTEGER  NOT NULL
			,admin_user_id INTEGER  NOT NULL
		);
## Understanding the Data Provided

There are two keys pieces of information to understand before you’re able to dive into a solution:

1. Users have a unique user ID for every team for which they are a member. That means that if **alice@slack-corp.com** signs up for multiple Slack teams, she will have two entries in the `users` table, each with the same email address, but a *different* user ID and team ID.
2. A team can allow anyone with a specific email address to join; these domains are specified as a comma-separated list in a team’s `email_domain` column. For example, if `Team A` allows anyone with a `slack-corp.com` email to join, but **alice@slack-corp.com** hasn’t joined yet.
## How You’ll be Evaluated

First and foremost, we’re looking for a solution that address all of the requirements:

1. Correctly shows the set of teams (id, and name) for which a user is a member.
2. Correctly shows the set of teams (id, name, and member count) that a user is eligible to join.
3. The set of teams a user is eligible for listed in decreasing number of members.

We’ll also be evaluating your solution for succinct, well-organized, and well-tested code.

**Here’s a hint to get you started:** daffy_duck@qa.com is a member of 2 teams in the data provided and is eligible to join 27 teams.

Good luck!

