#!/bin/bash
# connect the db
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN(){
  echo "Enter your username:"
  read USER_NAME
  # let's check if exists
  FIND_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME' ")
  if [[ -z $FIND_USER_ID ]]
  then
    # add username
    INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USER_NAME')")
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    # recover the new_user_id
    FIND_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME';")
  else # user exists
    # the name must be recovered from the database
    FIND_USER_NAME=$($PSQL "SELECT username FROM users WHERE username = '$USER_NAME';")
    # get games played
    GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) as games_played FROM games WHERE user_id=$FIND_USER_ID;")
    # get best game
    BEST_GAME=$($PSQL "SELECT MIN(attempts) as low_attempts FROM games WHERE user_id=$FIND_USER_ID;")
    echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
  # Generate a random number between 1 and 1000
  RANDOM_NUMBER=$(( 1 + $RANDOM % 1000 ))
}
MAIN
