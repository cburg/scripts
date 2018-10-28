#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Merge Xresources
xrdb -merge "${HOME}/.Xresources"

if [[ $1 == "gnome" ]]; then
	gdm
	#exec gnome-session
elif [[ $1 == "awesome" ]]; then
	exec awesome
else
	echo "Choose a window manager"
fi
