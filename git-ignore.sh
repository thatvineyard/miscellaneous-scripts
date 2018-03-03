#!/bin/bash

IGNORE_FILE='.gitignore'

if [ -f $IGNORE_FILE ] ; then
    echo $IGNORE_FILE "found."
    :
else
    echo $IGNORE_FILE "not found. Creating."
    echo "# Created by git-ignore" > $IGNORE_FILE
fi

if [ $# -gt 0 ] ; then
    # echo "Adding $# lines to .gitignore"
    for ARG in $@; do
        
        EXISTS=false;
        # echo "Checking reduncancy for \"$ARG\""
        
        while read -r IGNORE_LINE; do
            if [ "$IGNORE_LINE" == $ARG ] ; then
                EXISTS=true
            fi
        done < $IGNORE_FILE

        if ! [ $EXISTS == true ] ; then
            echo "Adding \"$ARG\""
            echo "$ARG" >> $IGNORE_FILE
        else
            echo "\"$ARG\" already exists in $IGNORE_FILE"
        fi

    done
else 
    # echo "Need at least one parameter"
    :
fi