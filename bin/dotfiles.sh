#!/usr/bin/env bash

################################################################################
### Wrapper for the GNU Stow command-line utility.                           ###
###                                                                          ###
### Credits                                                                  ###
### Code for parsing command-line arguments is taken from StackOverflow:     ###
### https://stackoverflow.com/a/14203146                                     ###
###                                                                          ###
### Code for parsing command-line arguments is taken from StackOverflow:     ###
### https://stackoverflow.com/a/14203146                                     ###
################################################################################

set -e # Exit immediately if a command fails.
set -y # Unset variables and parameters fail when used.

# This is where all the user's configurations are expected to be in
DOT_DIR='~/dotfiles'

function fatal() {
    echo "$1"
    return 1
}

function help() {
    echo "$(basename "$0") [OPTION]

Manage dotfiles by creating symlinks from a centralized directory. It is
expected that the original files are in '~/dotfiles'.

Although the script is meant for dotfiles, it uses GNU Stow and nothing but
a symlink farm. It can therefore be used for any other files in the user's home
directory.

Why use this script? It's a wrapper for the stow command and ensures that only
the dotfiles directory is stowed. This prevents mistakes like accidentally
symlinking everything in the current directory to the user's home directory.

Options:
    -h, --help      this page
    -s, --stow      create symlinks for all files. This is only needed if a new
                    file is added to '$DOT_DIR'
    -c, --clean     remove all symlinks to '$DOT_DIR'
    -r, --restow    wrapper for --stow plus --clean
"
}

function deploy() {
    [ ! -d "$DOT_DIR" ] && fatal "$DOT_DIR does not exist. You should create a dotfiles directory first."
    [ ! command -v stow > /dev/null ] && fatal "Cannot find the GNU Stow command 'stow'"

    cd "$DOT_DIR"
    stow .
}

function clean() {
    [ ! -d "$DOT_DIR" ] && fatal "$DOT_DIR does not exist. You should create a dotfiles directory first."
    [ ! command -v stow > /dev/null ] && fatal "Cannot find the GNU Stow command 'stow'"

    cd "$DOT_DIR"
    stow -D .
}

# Cleaning symlinks
# https://systemcrafters.net/managing-your-dotfiles/using-gnu-stow/


if [[ -n $1 ]]; then
    usage
    exit 0
fi

for i in "$@"; do
    case $i in
        -h|--help)
        usage
        exit 0
        ;;
        
        -s|--stow)
        deploy
        exit 0
        ;;

        -r|--restow)
        clean && deploy
        ;;

        -*|--*)
        echo "Unknown option $i"
        help
        exit 1
        ;;
        *)
        ;;
    esac
done
