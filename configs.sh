#!/bin/bash

BACKUPDIR="$( dirname "${BASH_SOURCE[0]}" )"/configs
RESTOREDIR=$HOME

TARGET_CONFIGS=(
    # Multimedia (Music Mostly)
    .abcde.conf
    .config/MusicBrainz/Picard.ini
    .config/mpd/mpd.conf
    .ncmpcpp/config
    # Editors
    .vimrc
    .emacs
    .config/Code/User/keybindings.json
    .config/Code/User/settings.json
    # Window Managers
    .config/awesome/rc.lua
    .config/bspwm/bspwmrc
    .config/sxhkd/sxhkdrc
    .xinitrc
    # Terminals
    .screenrc
    .Xresources
    .gconf/apps/gnome-terminal/profiles/Default/
)

function backup () {
    echo "Backing up configs..."
    for i in ${TARGET_CONFIGS[*]}; do
        FROM=$RESTOREDIR/$i
        TO=$BACKUPDIR/$i
        NEWDIR="$( dirname "$TO" )"
        mkdir -p $NEWDIR
        cp -r $FROM $TO
    done

    # We'll specially backup our ~/.bashrc, but we don't want to blindly restore
    # it at this time so we're keeping it out of the list above.
    cp ~/.bashrc $BACKUPDIR/.bashrc

    OS=`cat /etc/*-release | grep ^PRETTY_NAME | sed 's/PRETTY_NAME=//' | sed 's/"//g'`
    TIME=`date -u -Iseconds`
    echo $OS $TIME >> $BACKUPDIR/history.log
    echo "Done!"
}

function restore () {
    echo "Restoring configs..."
    for i in ${TARGET_CONFIGS[*]}; do
        FROM=$BACKUPDIR/$i
        TO=$RESTOREDIR/$i
        NEWDIR="$( dirname "$TO" )"
        mkdir -p $NEWDIR
        cp -r $FROM $TO
    done
    echo "Done!"
}

if [[ "$1" == "backup" ]]
then
    backup
elif [[ "$1" == "restore" ]]
then
    restore
fi
