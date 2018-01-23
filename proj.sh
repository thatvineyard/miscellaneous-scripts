#!/bin/bash

## DEPENDENCY
# This function uses display-error which is also a script in the miscellaneous scripts pack. 

## VARIABLES
P_DIR_LIST=(/home/carl/Documents/UU/AD2/Assignments/ /home/carl/Documents/UU/AD2/)
NUM_PROJECTS=${#P_DIR_LIST[@]}
BROWSER= 

## FUNCTIONS
display_help() {
    echo "Call on a specific project number N using \"proj N\""
    if [[ $PLAST_DIR ]] ; then
	Call "most recently called project using \"proj 0\""
	echo "======="
	echo "Most recent project \($0\):"
	echo $PLAST_DIR
    fi

    for i in `seq 0 $((NUM_PROJECTS-1))`; do
	echo "======="
	echo "Project $i:"
	echo ${P_DIR_LIST[$i]}
    done
    echo =======
}

open_terminal() {
    if [ $1 ] ; then
	case $(basename $(readlink -f $(which x-terminal-emulator))) in
	    tilix.wrapper)
		x-terminal-emulator -w $1 --maximize --action=session-add-right
		;;
	    *)
		x-terminal-emulator
		;;
	esac
    fi
}
       
open_project() {
    P_DIR=$1

    cd $P_DIR &> /dev/null
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

	if [ ${P_GIT} = true ] ; then
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

if [[ $1  && $1 < $NUM_PROJECTS ]]; then
    open_project ${P_DIR_LIST[$1]}
else
    display_help
fi

