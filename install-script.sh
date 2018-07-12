#!/bin/bash


emacssettingsdir=$HOME/.emacs.d/
emacssettingsgit=git@github.com:/thatvineyard/.emacs.d.git 


bashsettingsdir=$HOME/.bashrc.d-test/
bashsettingsgit=git@github.com:/thatvineyard/.bashrc.git 


miscscriptsdir=/usr/local/bin/miscellaneous-scripts
miscscriptsgit=git@github.com:/miscellaneous-scripts.git


header="######## INSTALLER SCRIPT ##########"
footer="####################################"

print_header() {
    echo $header;
    echo $1;
    echo $footer;
}

print_message() {
    echo "###############" $1
}


install_updateupgrade() {
    print_message "Update and upgrade full system"
    sudo apt update
    sudo apt upgrade
}

install_programs() {
    print_message "Installing git, emacs and code"
    sudo apt -qq install -y git emacs code
}

install() {
    print_header "Updating, upgrading and installing programs"

    install_updateupgrade
    install_programs
    
    print_message "Installation complete"
}




configure_git() {
    gitconfig="git config --global"

    print_message "configuring git"
    
    $gitconfig user.name "Carl Wingårdh"
    $gitconfig user.email "c.a.wingardh@gmail.com"

    $gitconfig core.editor "emacs -nw"
    $gitconfig help.autocrrect "10"
    
    $gitconfig github.user "thatvineyard"
}

configure_bash() {
    print_message "Configuring bash"
    git clone $bashsettingsgit $bashsettingsdir
}

configure_vscode() {
    print_message "No configuration for vscode as of now, please implement manually"
    }

configure() {
    print_header "Configuring"

    configure_git
    configure_bash
    configure_vscode
    
    print_message "Configuration complete"
}




download_misc() {
    print_message "downloading miscellaneous scripts"
    git clone $miscscriptsgit $miscscriptsdir
}

    
download() {
    print_header "Downloading extra files"

    download_misc

    print_message "Downloading complete"
}
    

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
