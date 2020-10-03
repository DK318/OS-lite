#!/bin/bash

ps aux --sort +start | tail -n 4 | awk 'NR==1{print $2, $9;}'
