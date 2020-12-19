#!/bin/bash

pids=$(ps ax -o pid | tail -n +2)
max=-1
max_pid=-1
for dir in $pids
do
	if [[ -d /proc/$dir/  ]]; then
		sz=$(cat "/proc/$dir/statm" | awk '{print $2}')
		if [[ $sz -gt $max  ]]; then
			max=$sz
			max_pid=$dir
		fi
	fi
done
echo "$max_pid"
echo "$max"
