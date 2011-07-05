#!/bin/bash

function run {
    nohup ./$1/$1.exe --opa-server-port $2 --logs-path ./$1 > ./$1/stdout.log 2> ./$1/stderr.log &
}

case $1 in
    watch)
        run watch 5000;;
    watch_slow)
        run watch_slow 5001;;
esac
