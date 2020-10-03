#!/bin/bash

list=$(ls /sbin/ | tr '\n' ',' | sed "s/,$//")
ps -C $list o pid > pids
