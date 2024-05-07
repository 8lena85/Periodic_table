#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If you run ./element.sh, 
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi
  
# If you run ./element.sh is number
if [[ $1 =~ ^[1-9]$|^10$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
# If you run ./element.sh SYMBOL or NAME
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' or symbol = '$1'")
fi

# no such element
if [[ -z $ELEMENT ]]
then
  echo  "I could not find that element in the database."
  exit
fi


echo $ELEMENT | while IFS=" |" read ATOMIC_NUMBER ATOMIC_NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
  echo "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
