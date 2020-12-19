#!/bin/bash

list=$(ls /sbin/ | tr '\n' ',' | sed "s/,$//")
ps -C "$list" o pid | sed "s/\s*//" | tail -n +2 > pids
