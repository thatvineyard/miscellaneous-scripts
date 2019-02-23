# miscellaneous-scripts
A collection of miscellaneous scripts which are too small to be their own project. 

- [miscellaneous-scripts](#miscellaneous-scripts)
  - [install-script](#install-script)
    - [Usage](#usage)
  - [git-ignore](#git-ignore)
    - [Usage](#usage-1)
  - [print-header](#print-header)
    - [Usage](#usage-2)
  - [run-in-temp-terminal](#run-in-temp-terminal)
  - [display-error](#display-error)
    - [Usage](#usage-3)
  - [proj](#proj)
    - [Usage](#usage-4)

## install-script
An installer script. Constist of three steps: install, configure, download. 

- Install
  - Curl
  - Git
  - Emacs
  - Tilix
  - Vs Code
- Configure
  - Git
  - Emacs
  - Vs Code
  - Wallpaper
  - Default terminal
- Download
  - miscellaneous-scipts (this repo)

### Usage

Run by calling `install-script.sh`. 

Requires minimal user input, closer to the end of the process. 

## git-ignore
Looks for a git-ignore file, creates one if none exists, and adds the arguments to that file. 

### Usage

Run by calling `git-ignore.sh [LINE TO ADD TO .gitignore]` in the root folder of a git repo. 

## print-header

Nicely prints a message with a top and bottom line, header, vertical and horizontal spacing. 

**Flags**
- `-h` Help
- `-H` Header - Change the message in the top line
- etc...

### Usage

`print-header -H Urgent -c ! Do not proceed unless you know what you are doing`

`cat /var/log/access | grep "ssh" | print-header -H Access`

`print-header -f /etc/motd`

## run-in-temp-terminal

Uses tilix to run a command in a temporary terminal. 

## display-error
A small script to format errors. It uses fold to wrap the errors so they are more readable. Unfortunately it does not allow newlines in the error message, but I will look into it.

### Usage

`display-error`

Displays the error box with a generic error message

`display-error [ERROR MESSAGE]`

Displays the error box with the error message within it. 

## proj
This is a script which lets you keep track of current projects and set up the corresponding environment. 

It will open emacs and a specified terminal layout.

It can detect is a project is within a git repository and will pull when initializiing. 

### Usage
proj

Lists the available projects.

proj X

Opens the project at number X. 