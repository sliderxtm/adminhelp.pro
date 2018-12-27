#!/usr/bin/xdotool
        search --onlyvisible --classname $1

        windowsize %@ $2 $3
        windowraise %@

        windowmove %1 0 0
        windowmove %2 $2 0
        windowmove %3 0 $3
        windowmove %4 $2 $3
