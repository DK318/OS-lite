#!/bin/bash

let cnt=$(ps -u dk318 | wc -l)-2
echo "Processes executed: $cnt"
ps -u dk318 o pid,command
