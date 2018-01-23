#!/bin/bash

## DEPENDENCY
# This function uses display-error which is also a script in the miscellaneous scripts pack. 

## VARIABLES
P_DIR_LIST=(/home/carl/Documents/UU/AD3/AD3-Assignments/ /usr/local/bin/miscellaneous-scripts)
NUM_PROJECTS=${#P_DIR_LIST[@]}
BROWSER= 

## FUNCTIONS
display-help() {
    echo "===================================================="
    echo "Call on a specific project number N using \"proj N\""
    echo
    echo "To set a project directory, stand in the directory"
    echo "and use \"proj set N\" to set that project numeber"
    echo "directory to the current directory"
    echo "===================================================="
    if [[ $PLAST_DIR ]] ; then
	Call "most recently called project using \"proj 0\""
	echo "======="
	echo "Most recent project \($0\):"
	echo $PLAST_DIR
    fi

    echo
    
    for i in `seq 0 $((NUM_PROJECTS-1))`; do
	echo "=======" "Project $((i+1)):" "=======" 
	echo "Directory:" ${P_DIR_LIST[$i]}
	echo
    done

    echo
    echo "===================================================="
}

open_terminal() {
    if [ $1 ] ; then
	case $(basename $(readlink -f $(which x-terminal-emulator))) in
	    tilix.wrapper)
		tilix w $1 --maximize --action=session-add-right
		;;
	    *)
		x-terminal-emulator
		;;
	esac
    fi
}
       
open_project() {
    P_DIR=$1
    
    source cd $P_DIR
    if [ $? -eq 0 ] ; then
	
	# emacs &
	open_terminal $P_DIR &
	
	if git rev-parse --git-dir > /dev/null 2>&1; then
	    # This is a valid git repository (but the current working
	    # directory may not be the top level.
	    # Check the output of the git rev-parse command if you care)
	    echo "Valid git repo"
	    P_GIT= true
	else
	    # this is not a git repository
	    echo "Not a git repo"
	    P_GIT= false
	fi

	if [ ${P_GIT}] ; then
	    # git config --local --get remote.origin.url | xargs -I {} $BROWSER {} &
	    git pull &
	fi

	ls -l

	export PLAST_DIR=$P_DIR;
	export PLAST_GIT=$P_GIT;

    else
	display-error $(echo "Changing directory unsuccessful, please verify that project directory exists" "Project directory:" $P_DIR)
    fi
}


## MAIN

if [ $1 ] ; then

    if [ $1 = "set" ] ; then
	if [[ $2 && $2 < $((NUM_PROJECTS + 1)) && $2 > 0 ]] ; then
	    echo "Setting directory for project" $2
	    P_DIR_LIST[$(($2 - 1))]=$(pwd)
	else
	    display-error $(echo "Project number undefined." "Should be between 1 and" $NUM_PROJECTS)
	fi
    fi
    
    if [[ $1 -eq $1 && $1 < $((NUM_PROJECTS + 1)) ]] ; then
	if [ $1 = 0 ]; then
	    if [ $PLAST_DIR ] ; then
		open_project $PLAST_DIR
	    else
		display-error $(echo "No last project")
	    fi
	else
	    cd ${P_DIR_LIST[$(($1 - 1))]}
	fi
    fi
else
    display-help
fi

