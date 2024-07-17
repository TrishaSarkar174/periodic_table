#!/bin/bash

# Database connection string
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Determine if input is a number or a string
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1"
  else
    QUERY="SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'"
  fi

  # Execute the query
  ELEMENT=$($PSQL "$QUERY")

  # Check if element is found
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    # Format the output
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
