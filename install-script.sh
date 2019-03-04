#!/bin/bash

#==============================================================================
# install-script.sh
#==============================================================================
#
# Written by Carl Wingårdh
# 2018/07/12
#
# Runs a number of functions to install my default programs and configurations.
#   Installs: git, emacs, curl, tilix and vs code
#
# Sections:
#   - Directories, repos, urls
#   - Formatting
#   - Installing
#   - Configuring
#   - Downloading
#   - Main
#
#==============================================================================


#------------------------------------------------------------------------------
# Directories, repos, urls
#------------------------------------------------------------------------------
#
# All directories, git repos and other urls are defines here. 
#
#------------------------------------------------------------------------------
emacssettingsdir=$HOME/.emacs.d/
bashsettingsdir=$HOME/.bashrc.d/
miscscriptsdir=/usr/local/bin/miscellaneous-scripts
codesettingsdir=~/.config/Code/User
wallpaperdir=~/Pictures/Wallpapers

emacssettingsgit=git@github.com:/thatvineyard/.emacs.d.git 
bashsettingsgit=git@github.com:/thatvineyard/.bashrc.git 
miscscriptsgit=git@github.com:/thatvineyard/miscellaneous-scripts.git
codesettingsgit=git@github.com:/thatvineyard/vscode-settings.git

wallpaperimageurl='https://docs.google.com/uc?export=download&id=1172_3C4vW2KXqAW-VvM26UT-oqeM6NXr'
lockscreenimageurl='https://docs.google.com/uc?export=download&id=17Fajqu8dWKGB8b7lWPQxp9XsIFwAAaRC'


#------------------------------------------------------------------------------
# Formatting
#------------------------------------------------------------------------------
# 
# Functions used to format messages to make logging easier to see. 
#
#------------------------------------------------------------------------------
header="######## INSTALLER SCRIPT ##########"
footer="####################################"

## print_header
# 
# Prints a message with a header and footer to make seeing in the midst of other logging easier.
#
# $1 - Message to print in the header
# 
# Example: print_header hello
# 
#   STDOUT:
#       ######## INSTALLER SCRIPT ##########
#       hello
#       ####################################
# 
print_header() {
    echo $header;
    echo $*;
    echo $footer;
}

## print_message
# Prints a message with a prefix to make seeing in the midst of other logging easier.
#
# $1 - Message to print with the prefix
# 
# Example: print_message hello
# 
#   STDOUT:
#       ############### hello
# 
print_message() {
    echo "############### " $*
}


#------------------------------------------------------------------------------
# Install
#------------------------------------------------------------------------------
#
# Installing functions. Some applications need to add their own repo. 
#
#------------------------------------------------------------------------------

## install_updateupgrade
#
# Runs apt update and upgrade. 
#
install_updateupgrade() {
    print_message "Update and upgrade full system"
    sudo apt update -y
    sudo apt upgrade -y
}

## install_code
# 
# Adds vscode's repo to apt sources, then installs it.
#
install_code() {
    print_message "Installing code"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt -qq install -y code
}

## install_programs
# 
# Installs git, emacs, curl and tilix. 
#
install_programs() {
    print_message "Installing git, emacs, curl and tilix"
    sudo apt -qq install -y git emacs curl tilix
}

## install
# 
# Main install function. 
#
install() {
    print_header "Updating, upgrading and installing programs"

    install_updateupgrade
    install_programs
    install_code
    
    print_message "Installation complete"
}


#------------------------------------------------------------------------------
# Configure
#------------------------------------------------------------------------------
#
# Pulls configurations files from my personal git repos and puts them in the
# appropriate folders. 
#
#------------------------------------------------------------------------------

## configure_git
#
# Sets the global git config to my default settings. 
#
configure_git() {
    gitconfig="git config --global"

    print_message "configuring git"
    
    $gitconfig user.name "Carl Wingårdh"
    $gitconfig user.email "c.a.wingardh@gmail.com"

    $gitconfig core.editor "emacs -nw"
    $gitconfig help.autocorrect "10"
    
    $gitconfig github.user "thatvineyard"
}

## initalize_remote_git_in_existing_directory
#
# A small script which allows git to set up a git repo in a non-empty directory. 
#
# $1 git repository URL
# $2 directory to initialize in
#
initialize_remote_git_in_existing_directory() {
    if [ $# -eq 2 ]; then
        previous_directory=pwd
        cd $2

        if [[ $? -eq 0 ]]; then
            mkdir $2
        fi

        git init
        git remote add origin $1
        git fetch
        git reset origin/master 
        git checkout -t origin/master

        cd $previous_directory
    fi
}

## initalize_remote_git_in_new_directory
#
# A small script which allows git to set up a git repo in a new directory. 
# Only used to make a distinction between this and in a non-empty directory. 
#
# $1 git repository URL
# $2 directory to initialize in
#
initialize_remote_git_in_new_directory() {
    git clone $1 $2
}

## initialize_remote_git
#
# Initializes a git repo in a directory whether or not it exists already 
# or not. 
#
# $1 git repository URL
# $2 directory to initialize in
#
initialize_remote_git_in_directory() {
    if [ -d "$2" ]; then 
        print_message "$2 already exists, initializing into repo"
        initialize_remote_git_in_existing_directory $1 $2
    else
        print_message "$2 does not exist, cloning repo"
        initialize_remote_git_in_new_directory $1 $2
    fi
}

## configure_bash
#
# Pulls my bash settings repo into the bash directory. Note that
# this function does not change the current .bashrc. You must manually
# create a symlink or copy the relevant bash settings. 
#
configure_bash() {
    print_message "Configuring bash"
    initialize_remote_git_in_directory $bashsettingsgit $bashsettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for bash failed"
    fi
}

## configure_vscode
#
# Pulls my vscode settings into the code settings directory. 
#
configure_vscode() {
    print_message "Configuring code"

    initialize_remote_git_in_directory $codesettingsgit $codesettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for code failed"
    fi
}

## configure_emacs
#
# Pulls my emacs settings into the emacs settings directory. 
#
configure_emacs() {
    print_message "Configuring emacs"

    initialize_remote_git_in_directory $emacssettingsgit $emacssettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for emacs failed"
    fi
}

## set_wallpaper
#
# Uses gsettings to set the background image. 
#
# $1 filepath to background image. 
#
set_wallpaper() {
    gsettings set org.gnome.desktop.background picture-uri "file://$1"
}

## set_lockscreen
#
# Uses gsettings to set the lockscreen image. 
#
# Currently not implemented since gsettings doesn't support this configuration. 
#
# $1 filepath to lockscreen image. 
#
set_lockscreen() {
    print_message "Not implemented yet"
}

## configure_background_images
#
# Downloads and sets background and lockscreen images. 
# 
# Currently not activated. 
#
configure_background_images() {
    print_message "Configuring background images"

    mkdir $wallpaperdir 2> /dev/null

    # wget --no-check-certificate $wallpaperimageurl -O $wallpaperdir/wallpaper.png
    # wget --no-check-certificate $lockscreenimageurl -O $wallpaperdir/lockscreen.png

    set_wallpaper $wallpaperdir/wallpaper.png
    set_lockscreen $wallpaperdir/lockscreen.png

}

## configure_terminal
#
# Sets the default terminal. Requires user input. 
#
configure_terminal() {
    print_message "Configuring terminal"

    sudo update-alternatives --config x-terminal-emulator

}

## configure
# 
# Main configure function. 
#
configure() {
    print_header "Configuring"

    configure_git
    configure_bash
    configure_vscode
    configure_emacs
    #configure_background_images
    configure_terminal

    print_message "Configuration complete"
}


#------------------------------------------------------------------------------
# Download
#------------------------------------------------------------------------------
#
# Downloads any extra files that are not part of a confiuration. 
#
#------------------------------------------------------------------------------
download_misc_scripts() {
    user=$whoami
    print_message "downloading miscellaneous scripts"
    initialize_remote_git_in_directory $miscscriptsgit $miscscriptsdir
    sudo chown $user:$user $miscscriptsdir
}

## download
# 
# Main download function. 
# 
download() {
    print_header "Downloading extra files"

    download_misc_scripts

    print_message "Downloading complete"
}
    
#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------
#
# The main script.
#
#------------------------------------------------------------------------------
if [ $# -eq 0 ]
then
    install
    configure
    download
else
    if [ $1 = "install" ]
    then
	install
    fi
    if [ $1 = "configure" ]
    then
	configure
    fi
    if [ $1 = "download" ]
    then
	download
    fi
fi
