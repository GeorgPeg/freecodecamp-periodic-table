#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  # When no argument provided
  echo "Please provide an element as an argument."
else
  # Test whether input is a number and find atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  # Test whether element is in database and find details
  if [[ -z $NUM ]]
  then
    echo "I could not find that element in the database."
  else
    # Look up data
    PROP=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius
      FROM properties WHERE atomic_number = $NUM")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties 
      WHERE atomic_number = $NUM")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    ELEM=$($PSQL "SELECT atomic_number, symbol, name FROM elements 
      WHERE atomic_number=$NUM")
    # Print output
    echo "$TYPE$ELEM$PROP" | while read TYPE NUM BAR SYMBOL BAR NAME MASS BAR MELT BAR BOIL
    do
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done  
  fi
fi
