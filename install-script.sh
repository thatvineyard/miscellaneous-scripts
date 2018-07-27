#!/bin/bash


emacssettingsdir=$HOME/.emacs.d/
emacssettingsgit=git@github.com:/thatvineyard/.emacs.d.git 


bashsettingsdir=$HOME/.bashrc.d/
bashsettingsgit=git@github.com:/thatvineyard/.bashrc.git 


miscscriptsdir=/usr/local/bin/miscellaneous-scripts
miscscriptsgit=git@github.com:/thatvineyard/miscellaneous-scripts.git


codesettingsdir=~/.config/Code/User
codesettingsgit=git@github.com:/thatvineyard/vscode-settings.git

wallpaperdir=~/Pictures/Wallpapers
wallpaperimageurl='https://docs.google.com/uc?export=download&id=1172_3C4vW2KXqAW-VvM26UT-oqeM6NXr'
lockscreenimageurl='https://docs.google.com/uc?export=download&id=17Fajqu8dWKGB8b7lWPQxp9XsIFwAAaRC'

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
    sudo apt update -y
    sudo apt upgrade -y
}

install_code() {
    print_message "Setting up code repository"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt -qq install -y code
}

install_programs() {
    print_message "Installing git, emacs, curl, tilix and code"
    sudo apt -qq install -y git emacs curl tilix
    install_code
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

initalize_remote_git_in_existing_directory() {
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

        cd $pwd
    fi
}

initialize_remote_git_in_new_directory() {
    git clone $1 $2
}

configure_bash() {
    print_message "Configuring bash"
    initialize_remote_git_in_new_directory $bashsettingsgit $bashsettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for bash failed"
    fi
}

configure_vscode() {
    print_message "Configuring code"

    initalize_remote_git_in_existing_directory $codesettingsgit $codesettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for code failed"
    fi
}

configure_emacs() {
    print_message "Configuring emacs"

    initalize_remote_git_in_existing_directory $emacssettingsgit $emacssettingsdir

    if [ $? -eq 0 ]; then
        print_message "Initializing git repository for emacs failed"
    fi
}

set_wallpaper() {
    gsettings set org.gnome.desktop.background picture-uri "file://$1"
}

set_lockscreen() {
    echo 'hello'
}

configure_background_images() {
    print_message "Configuring background images"

    mkdir $wallpaperdir 2> /dev/null

    # wget --no-check-certificate $wallpaperimageurl -O $wallpaperdir/wallpaper.png
    # wget --no-check-certificate $lockscreenimageurl -O $wallpaperdir/lockscreen.png

    set_wallpaper $wallpaperdir/lockscreen.png
    set_lockscreen $wallpaperdir/lockscreen.png

}

configure_terminal() {
    print_message "Configuring terminal"

    update-alternatives --config x-terminal-emulator

}

configure() {
    print_header "Configuring"

    configure_git
    configure_bash
    configure_vscode
    configure_emacs
    configure_background_images
    configure_terminal

    print_message "Configuration complete"
}




download_misc() {
    print_message "downloading miscellaneous scripts"
    sudo git clone $miscscriptsgit $miscscriptsdir
    sudo chown $whoami:$whoami $miscscriptsdir
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
