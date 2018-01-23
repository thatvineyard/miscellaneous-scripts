#!/bin/bash

display_help() {
    echo Call on a specific project number N using \"proj N\"
    if [[ $PLAST_DIR || $PLAST_GIT ]] ; then
	Call most recently called project using \"proj 0\"
	echo =======
	echo Project $0:
	if [ $PLAST_GIT = true ] ; then
	    echo git-enabled
	else
	    echo git-disabled
	fi
	echo $PLAST_DIR
    fi

    for i in `seq 1 $num_projects`; do
	DIR_VAR=P${i}_DIR
	GIT_VAR=P${i}_GIT

	echo =======
	echo Project $i:
	if [ ${!GIT_VAR} = true ] ; then
	    echo git-enabled
	else
	    echo git-disabled
	fi
	echo ${!DIR_VAR}
    done
    echo =======
}

open_project() {
    P_DIR = $1

    cd ${P_DIR}
    emacs &
    gnome-terminal &
    
    cd ${P1_DIR}
    if git rev-parse --git-dir > /dev/null 2>&1; then
	: # This is a valid git repository (but the current working
	# directory may not be the top level.
	# Check the output of the git rev-parse command if you care)
    else
	: # this is not a git repository
    fi

    if [ ${P1_GIT} = true ] ; then
	git config --local --get remote.origin.url | xargs -I {} google-chrome-stable {} &
	git pull &
    fi

    ls -l

    export PLAST_DIR=$P_DIR;
    export PLAST_GIT=$P_GIT;

}

num_projects=2

P1_DIR=/home/carl/Documents/UU/AD2/Assignments/
P2_DIR=/home/carl/Documents/UU/AD2/

if [ $1 ]; then
    # Set variables accordingly
    # if the variable is undefined, 
    
    case $1 in
	1)    open_project $P1_DIR
	      ;;
	2)    open_project $P2_DIR
	      ;;
	*)
	    display_help
	      ;;
    esac    
else
    display_help
fi


