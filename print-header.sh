#!/bin/bash


topline="================ Error =================\n"
startmainline="\t"
endmainline=""

file=false
pipe=false
messagewidth=40
terminalwidth=60
linespacing=2
character=\=
header=Message
spacingperside=2

strU8DiffLen () {
    local bytlen oLang=$LANG
    oLcAll=$LC_ALL
    LANG=C
    LC_ALL=C
    bytlen=${#1}
    LANG=$oLang LC_ALL=$oLcAll
    return $(( bytlen - ${#1} ))
}

function print_top {
    messagelength=$(echo $1 | wc -c)

    offset=$(((messagelength + marginalperside + $3 + 1) % 2))
    leftsidelength=$((($3 / 2) - ($messagelength / 2) - $spacingperside))
    rightsidelength=$((($3 / 2) - ($messagelength / 2) - $spacingperside + $offset))


    eval printf "%0.s$2" {1..$leftsidelength}
    if [[ $spacingperside -ne 0 ]] ; then 
	eval printf "%0.s' '" {1..$spacingperside}
    fi
    printf $1
    if [[ $spacingperside -ne 0 ]] ; then 
	eval printf "%0.s' '" {1..$spacingperside}
    fi
    eval printf "%0.s$2" {1..$rightsidelength}
    printf "\n"
    for i in $(seq 1 $linespacing); do
	printf "\n"
    done
}

function print_tail {
    for i in $(seq 1 $linespacing); do
	printf "\n"
    done

    eval printf "%0.s$1" {1..$2}
    printf "\n"
}

function print_main {
    file=$1
    shift
    pipe=$1
    shift

    
    if [[ $terminalwidth -gt $messagewidth ]]; then 
	prefixlength=$((($terminalwidth - $messagewidth) / 2))
	prefix=$(eval printf "%0.s' '" {1..$prefixlength})
    else
	prefix=''
    fi

    if [[ $messagewidth -ne 0 ]]; then
	if [[ $file = true ]]; then
	    if [[ $pipe = true ]]; then
		while read -r line ; do
		    fold -s --width $messagewidth $line |  sed "s/^/$prefix/"
		done
	    fi
	    while test $# -gt 0; do
  		fold -s --width $messagewidth $1 |  sed "s/^/$prefix/"
		shift
	    done
	elif [[ $pipe = true ]]; then
	    while read -r line ; do
		fold -s --width $messagewidth <<< $line |  sed "s/^/$prefix/"
	    done
	else
	    fold -s --width $messagewidth <<< $@ |  sed "s/^/$prefix/"
	fi
    else
	if [[ $file = true ]]; then
	    if [[ $pipe = true ]]; then
		while read -r line ; do
		    cat $line |  sed "s/^/$prefix/"
		done
	    fi
	    while test $# -gt 0; do
  		cat $1 |  sed "s/^/$prefix/"
		shift
	    done
	elif [[ $pipe = true ]]; then
	    while read -r line ; do
		echo $line |  sed "s/^/$prefix/"
	    done
	else
	    echo $@ |  sed "s/^/$prefix/"
	fi
    fi
	   
}

function print_header {
    character=$1
    shift
    messagewidth=$1
    shift
    terminalwidth=$1
    shift
    header=$1
    shift
    file=$1
    shift
    pipe=$1
    shift
    
    print_top $header $character $terminalwidth
    print_main $file $pipe $@
    print_tail $character $terminalwidth
}


if [ ! -t 0 ]; then
    pipe=true
fi

while test $# -gt 0; do
    case "$1" in
	-h|--help)
	    echo "$package - attempt to capture frames"
	    echo " "
	    echo "$package [options] application [arguments]"
	    echo " "
	    echo "options:"
	    echo "-h, --help                show brief help"
	    echo "-a, --action=ACTION       specify an action to use"
	    echo "-o, --output-dir=DIR      specify a directory to store output in"
	    exit 0
	    ;;
	-H)
	    shift
	    if test $# -gt 0; then
		header=$1
	    else
		echo "Header required after '-H' flag"
		exit 1
	    fi
	    shift
	    ;;
	-l)
	    shift
	    if test $# -gt 0; then
		linespacing=$1
	    else
		echo "Line spacing required after '-l' flag"
		exit 1
	    fi
	    shift
	    ;;
	-w)
	    shift
	    if test $# -gt 0; then
		messagewidth=$1
	    else
		echo "Message width required after '-w' flag"
		exit 1
	    fi
	    shift
	    ;;
	-t)
	    shift
	    if test $# -gt 0; then
		terminalwidth=$1
	    else
		echo "Terminal width required after '-t' flag"
		exit 1
	    fi
	    shift
	    ;;
	-c)
	    shift
	    if test $# -gt 0; then
		character=$1
	    else
		echo "Chacter required after '-c' flag"
		exit 1
	    fi
	    shift
	    ;;
	-s)
	    shift
	    if test $# -gt 0; then
		spacingperside=$1
	    else
		echo "Number required after '-s' flag"
		exit 1
	    fi
	    shift
	    ;;
	-f)
	    shift
	    file=true	    
	    ;;
	*)
	    break
	    ;;
    esac
done

print_header $character $messagewidth $terminalwidth $header $file $pipe $@
