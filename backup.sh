#!/bin/bash

# ncmpcpp config
# sublime config
# themes
# ssh files
# git config

BASEDIR=`pwd`

cd $HOME


# Awesome WM Config
# Sublime Text 3 Preferences
# Gnome Terminal Default Profile
# Urxvt.desktop (provides an icon)
# Gedit plugins and styles (themes)
# MPD config
# Ncmpcpp Config
# SSH Files (config, keys, etc)
# Vim plugins and Themes
# ABCDE config
# Bash config
# Git config
# Screen config
# Xinit config
# Xresources
FILELIST="
./.config/awesome/rc.lua
./.config/sublime-text-3/Packages/User/Preferences.sublime-settings
./.gconf/apps/gnome-terminal/profiles/Default/*
./.local/share/applications/urxvt.desktop
./.local/share/gedit/*
./.mpd/*
./.ncmpcpp/*
./.ssh/*
./.vim/*
./.abcde.conf
./.bashrc
./.gitconfig
./.screenrc
./.vimrc
./.xinitrc
./.Xresources"

FILENAME=""
FILENAME=$FILENAME`date +"%Y-%m-%d"`
FILENAME=$FILENAME"-"`cat /etc/*-release | grep ^NAME=\" | sed 's/NAME=//' | sed 's/"//g' | sed 's/\s/-/g'`".tar"

tar -cvf $FILENAME $FILELIST

mv $FILENAME $BASEDIR/$FILENAME
