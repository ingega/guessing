#!/bin/bash
# connect the db
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN(){
  echo "Enter your username:"
  read USER_NAME
  # let's check if exists
  FIND_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME' ")
  if [[ -z $FIND_USER ]]
  then
   echo "Welcome, $USER_NAME! It looks like this is your first time here."
  fi
  # Generate a random number between 1 and 1000
  RANDOM_NUMBER=$(( 1 + $RANDOM % 1000 ))
  # need a while to save the attempts, also a flag to control the loop
  FLAG=true
  # also need a variable to count the attempts
  ATTEMPTS=1  # at least is one shoot
  while $FLAG
  do
    echo "Guess the secret number between 1 and 1000:"
    read GUESS
    # first thing, if not a number, again until number
    SECOND_FLAG=true
    while $SECOND_FLAG
    do
      if ! [[ $GUESS =~ ^[0-9]+$ ]]
      then
        echo "That is not an integer, guess again:"
        read GUESS
      else
        SECOND_FLAG=false
      fi
    done
    # the number is an integer, so let's see if is above, behind or in the value
    if [[ $GUESS -eq $RANDOM_NUMBER ]]
    then
      echo "You guessed it in $ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
      exit -1
    else
      if [[ $GUESS -lt $RANDOM_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
      else
        echo "It's lower than that, guess again:"
      fi
      ATTEMPTS=$((ATTEMPTS + 1))
    fi
  done
}

MAIN
