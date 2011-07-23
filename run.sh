#!/bin/bash

function run {
    nohup ./$1/$1.exe --opa-server-port $2 --logs-path ./$1 > ./$1/stdout.log 2> ./$1/stderr.log &
}

case $1 in
    watch)
        run watch 5000;;
    watch_slow)
        run watch_slow 5001;;
    counter)
        run counter 5002;;
    iMage)
        run iMage 5003;;
    iMage-0)
        run iMage-0 5004;;
    iMage-1)
        run iMage-1 5005;;
    iMage-2)
        run iMage-2 5006;;
esac
