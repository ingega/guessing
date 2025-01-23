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
   echo "Welcome, $USER_NAME! It looks like this is your first time here."
  else # user exists
    # get games played
    GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) as games_played FROM games WHERE user_id=$FIND_USER_ID")
    # get best game
    BEST_GAME=$($PSQL "SELECT MIN(attempts) as low_attempts FROM games WHERE user_id=$FIND_USER_ID")
    echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
  # Generate a random number between 1 and 1000
  RANDOM_NUMBER=$(( 1 + $RANDOM % 1000 ))
  # if NaN then re-promt
  SECOND_FLAG=true
  ATTEMPTS=1 # there's at least one shoot
  while $SECOND_FLAG
  do
    echo "Guess the secret number between 1 and 1000:"
    read GUESS
    if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
      read GUESS
    else
      # is a number, check if low, high or match
      while true
      do
        if [[ $GUESS -eq $RANDOM_NUMBER ]]
        then
          echo "You guessed it in $ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
          # add to the db
          exit
        else
          if [[ $GUESS -lt $RANDOM_NUMBER ]]
          then
            echo "It's higher than that, guess again:"
            read GUESS
          else
            echo "It's lower than that, guess again:"
            read GUESS
          fi
          ATTEMPTS=$((ATTEMPTS + 1))
        fi
      done
    fi
  done
}

MAIN
