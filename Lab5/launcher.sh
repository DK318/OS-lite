#!/bin/bash

k="$1"
n=6400000
for ((i=0; i<k; i++)); do
    ./newmem.sh $n&
    sleep 1
done
