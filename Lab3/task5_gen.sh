#!/bin/bash

while true; do
	read line
	if [[ "$line" == "QUIT" ]]; then
		echo "$line" >> pipe
		break
	fi

	if [[ "$line" == "+" || "$line" == "*" || "$line" =~ [0-9]+ ]]; then
		echo "$line" >> pipe
	else
		echo "Bad input"
		echo "kek" >> pipe
		exit 1
	fi
done
