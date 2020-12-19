#!/bin/bash

proc=$(ps -u dk318 o pid,command | sed "s/^\s*//" | head -n -4 | tail -n +2)
cnt=$(echo "$proc" | wc -l)
echo "$cnt" > proc_count.log
echo "$proc" | awk '{print $1 ":" $2}' >> proc_count.log
