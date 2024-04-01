#!/usr/bin/bash

if command -v sxhkd &> /dev/null ; then
    kill -s SIGUSR1 $(ps -C sxhkd | grep sxhkd | awk '{print $1}')
    echo "sxhkd configuration reloaded"
fi
