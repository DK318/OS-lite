#!/bin/bash

pids=$(ps ax -o pid | sed "s/\s*//" | head -n -4 | tail -n +2)
for dir in $pids
do
	if [[ -d /proc/$dir/ ]]; then
		link=$(cat "/proc/$dir/cmdline" | awk '{print $1}')
		if [[ -n $link ]]; then
			echo "$dir $link"
		fi
	fi
done
