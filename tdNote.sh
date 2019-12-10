#!/bin/bash
#######################################
# bash exam
# author : kamil caglar
# mail : kamilcaglar.contact@gmail.com
#
# Note : `echo $'\n> ' this print a new line and > symbol
######################################


#######################################
# Verify if something is in array passed as parameter
# Arguments:
#   array
#   object to test
# Returns:
#   1 if IS NOT in array
#   0 if IS in array
#######################################
array_contains() {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${!array}"; do
    if [[ $element == "$seeking" ]]; then
      in=0
      break
    fi
  done
  return $in
}

function join_by { local IFS="$1"; shift; echo "$*"; }

choose_group() {
  #Get all the groups from groups file
  GROUPSARRAY=()
  while IFS=$'\t' read -r -a myArray; do
    GROUPSARRAY+=($myArray)
  done <groups
  GROUPSARRAY=("${GROUPSARRAY[@]:1}") #removed the 1st element

  echo "You are going to choose the groups of your user"

  chosenGroupsArray=()

  while true; do
    echo "Here are the different groups"
    (
      IFS=$'\n'
      echo "${GROUPSARRAY[*]}"
    )
    read -p "Choose one `echo $'\n> '`" choice

    array_contains GROUPSARRAY "$choice"
    result=$?

    if [ "$result" = "0" ]; then
      chosenGroupsArray+=($choice)
      read -p "OK, do you want to add more ? (y/n) `echo $'\n> '`" continue
        if [ "$continue" = 'n' ]; then
          break
        fi
    else
      echo "This group does not exist, please type anything and try again."
      read -p "`echo $'> '`"
    fi

  done


  var3=$(join_by , "${chosenGroupsArray[@]}")
  echo "$var3"
}


#Get all the users from users file
USERSARRAY=()
while IFS=$'\t' read -r -a myArray; do
  USERSARRAY+=($myArray)
done <users
unset "USERSARRAY[0]" #removed the 1st element

#######################################
# Main function
# Globals:
#   USERSARRAY
# Returns:
#   1 if IS NOT in array
#   0 if IS in array
#######################################

echo "Bienvenue dans le gestionnaire d'utilisateur"

action='p'
while [ $action != 'q' ]; do
  echo "What do you want to do ?"
  echo "a -> Add an user"
  echo "p -> Print the users"
  echo "q -> Exit"
  read -p "Enter your choice `echo $'\n> '`" action
  #Clear console
  clear && echo -en "\e[3J"

  if [ $action = 'p' ]; then
    INPUT=users
    OLDIFS=$IFS
    IFS=$'\t'
    [ ! -f $INPUT ] && {
      echo "$INPUT file not found"
      exit 99
    }
    while read login password groups date; do
      echo "Login : $login"
      echo "Password : $password"
      echo "Group : $groups"
      echo "Date : $date"
      echo ""
    done <$INPUT
    IFS=$OLDIFS
  fi
  if [ $action = 'a' ]; then

    echo "You are going to add an user"

    while true; do
      read -p "Login : `echo $'\n> '`" login

      #Récupération des users
      USERSARRAY=()
      while IFS=$'\t' read -r -a myArray; do
        USERSARRAY+=($myArray)
      done <users

      array_contains USERSARRAY "$login"
      var=$?

      if [ "$var" = "1" ]; then
        if [[ $login =~ ^[a-z]+([a-z0-9]){2,}$ ]]; then
          break
        else
          echo "Please use at least 2 characters in lowercase."
        fi
      else
        echo "This user is already registered."
      fi

    done

    while true; do
      read -p "Password : `echo $'\n> '`" password

      if ! [[ $password =~ [A-Za-z0-9@\#$%\&*+=-]{8,} && $password =~ [a-z] && $password =~ [A-Z] && $password =~ [0-9] && $password =~ [@\#$%\&*+=-] ]]; then
        echo "Please use at least 8 characters and 1 captial letter and 1 minuscule and 1 special character [@\#$%\&*+=-] and a number [0-9]."
      else
        read -p "Confirm password : `echo $'\n> '`" passwordConfirm
        if [ "$password" = "$passwordConfirm" ]; then
          break
        else
          echo "The passwords must be the same, please try again."
        fi
      fi

    done

    choose_group
    #var2=$(choose_group)

    echo $var2
    #Write results in the file
    echo -e "$login\t$password" >>users
  fi
done
