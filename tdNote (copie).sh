#!/bin/bash

#command=$(ls)
#echo $command



#Récupération des users
users=()
while IFS=$'\t' read -r -a myArray; do
  users+=($myArray)
done < users
#for i in "${users[@]}"
#do
#	echo $i
#done

echo "Bienvenue dans le gestionnaire d'utilisateur"

action='p'

while [ $action != 'q' ]
do
    echo "Que voulez-vous faire ?"
    echo "a -> Ajouter un user"
    echo "p -> Afficher les users"
    echo "q -> Quitter"
    read -p "Entrez votre choix" action
    clear && echo -en "\e[3J"
    if [ $action = 'p' ]
    then
        INPUT=users
        OLDIFS=$IFS
        IFS=$'\t'
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
        while read login password groups date
        do
            echo "Login : $login"
            echo "Password : $password"
            echo "Group : $groups"
            echo "Date : $date"
            echo ""
        done < $INPUT
        IFS=$OLDIFS
    fi
    if [ $action = 'a' ]
    then
        echo "Vous allez ajouter un user"

        while [ 1 ]
        do
            read -p 'Login :' login

            [[ $login =~ ^$ ]] && break || echo "Veuillez recommencer"
        done

        while [ 1 ]
        do
        read -p 'Password : ' password
            [[ $password =~ ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$*+-=@%&]).{8,}$ ]] && break || echo "Veuillez recommencer"
        done

 

        echo $login $Prenom >>users
    fi
done
