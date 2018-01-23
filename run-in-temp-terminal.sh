#!/bin/bash

if [[ $# > 0 ]] ; then
    case $(basename $(readlink -f $(which x-terminal-emulator))) in
	tilix.wrapper)
	    tilix -e $@
	    ;;
	*)
	    display-error "Default terminal is not compatible"
	    ;;
    esac
fi
