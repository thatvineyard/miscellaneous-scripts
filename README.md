# miscellaneous-scripts
A collection of miscellaneous scripts which are too small to be their own project. 

## proj
This is a script which lets you keep track of current projects and set up the corresponding environment. 

It will open emacs and a specified terminal layout.

It can detect is a project is within a git repository and will pull when initializiing. 

### Usage
proj

Lists the available projects.

proj X

Opens the project at number X. 

## display-error
A small script to format errors. It uses fold to wrap the errors so they are more readable. Unfortunately it does not allow newlines in the error message, but I will look into it.

### Usage

display-error

displays the error box with a generic error message

display-error [error message]

displays the error box with the error message within it. 
