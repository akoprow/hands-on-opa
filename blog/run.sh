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
    iMage-01)
        run iMage-01 5004;;
    iMage-02)
        run iMage-02 5005;;
    iMage-03)
        run iMage-03 5006;;
esac
