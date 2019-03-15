#!/bin/bash


# Input validation
if [ $# -lt 1 ] ; then
    echo "Must include a directory to search"
    exit 
fi

if [ -d "$1" ] ; then
    directory=$1
else
    echo "$1 is not a directory"
    exit 
fi




if [ "$2" != "" ] ; then
    search=$2
else
    search="*"
fi

echo "Searching for $search in directory"

# List directories
number=1
ls -1d $1/*/ | while read line ; do
    if [[ "$line" =~ "$2" ]] ; then
        echo " $number: $line"
        number=$((number+1))
    fi
done

# Get input
read -p "Pick a number: " choice

# Pick out right directory
number=1
ls -1d $1/*/ | while read line ; do
    if [[ "$line" =~ "$2" ]] ; then
        if [[ $number == $choice ]] ; then
            echo "Going to $line"
            echo "(if your diretory didn't change, add 'source' or '.' before command)"
            cd $line
        fi
        number=$((number+1))
    fi
done