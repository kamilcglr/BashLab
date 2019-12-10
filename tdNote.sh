#!/bin/bash

#Get all the users from user file
USERSARRAY=()
while IFS=$'\t' read -r -a myArray; do
  USERSARRAY+=($myArray)
done <users
for i in "${users[@]}"; do
  echo $i
done

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
  #echo $in
}

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
  echo "Que voulez-vous faire ?"
  echo "a -> Ajouter un user"
  echo "p -> Afficher les users"
  echo "q -> Quitter"
  read -p "Entrez votre choix" action
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
    echo "Vous allez ajouter un user"

    while true; do
      read -p 'Login :' login

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

      read -p 'Password : ' password

      if ! [[ $password =~ [A-Za-z0-9@\#$%\&*+=-]{8,} && $password =~ [a-z] && $password =~ [A-Z] && $password =~ [0-9] && $password =~ [@\#$%\&*+=-] ]]; then
        echo "Please use at least 8 characters and 1 captial letter and 1 minuscule and 1 special character [@\#$%\&*+=-] and a number [0-9]."
      else
        read -p 'Confirm password : ' passwordConfirm
        if [ $password = $passwordConfirm ]; then
          break
        else
          echo "The passwords must be the same, please try again."
        fi
      fi

    done

    #Write results in the file
    echo -e "$login\t$password" >>users
  fi
done
