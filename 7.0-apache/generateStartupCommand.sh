#!/bin/bash

CMDFILE="/opt/startup/startupCommand"
DEFAULT_COMMAND="/usr/sbin/apache2ctl -D FOREGROUND"

touch "$CMDFILE"

CUSTOM_STARTUP_COMMAND=`cat $CMDFILE`

if [ -z "$CUSTOM_STARTUP_COMMAND" ]
then
    startupCommand="$DEFAULT_COMMAND"
    echo "$startupCommand" >> "$CMDFILE"
fi
