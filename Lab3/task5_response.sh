#!/bin/bash

var=1
mode="+"
(tail -f pipe) |
while true; do
	read line
	if [[ "$line" == "QUIT" ]]; then
		break
	elif [[ "$line" == "+" || "$line" == "*" ]]; then
		mode="$line"
		echo "$mode mode"
	elif [[ "$line" =~ [0-9]+ ]]; then
		var=$(echo "$var $mode $line" | bc)
		echo "current var is: $var"
	else
		exit 1
	fi
done
