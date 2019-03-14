#!/bin/bash

number=1

ls -1d $1/*/ | while read line ; do
    if [[ "$line" =~ "$2" ]] ; then
	echo "$number: $line"
	number=$((number+1))
    fi
done

number=1
dir=""

ls -1d $1/*/ | while read line ; do
    if [[ "$line" =~ "$2" ]] ; then
	if [[ $number == $3 ]] ; then
	    cd $line
	fi
	number=$((number+1))
    fi
done
