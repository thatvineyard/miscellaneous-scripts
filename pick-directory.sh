#!/bin/bash


# Input validation
if [ $# -lt 1 ] ; then
    echo "Must have at least a directory to search"
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

echo "searching for $search in directory"


read -p "Pick a number: " number
echo "you picked $number"
