#!/bin/bash

topline="================ Error =================\n"
startmainline="\t"
endmainline=""
botline="\n========================================"

echo -e $topline

if [ $1 ] ; then
    fold -s --width 40 <<< $@
else
    echo -e $startmainline "Unspecified error" $endmainline
fi

echo -e $botline
