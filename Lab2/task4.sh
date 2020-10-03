#!/bin/bash

pids=$(ps ax -o pid)
file_name="cpu_burst.log"
if [[ -f $PWD/$file_name ]]; then
	rm -f $PWD/$file_name
fi
for dir in $pids
do
	if [[ "$dir" != "PID" ]]; then
		if [[ -d /proc/$dir ]]; then
			res+=$dir
			res+=" "
			res+=$(cat /proc/$dir/status | grep "PPid:" | awk '{print $2}')
			res+=" "
			art=$(cat /proc/$dir/sched | grep "se.sum_exec_runtime" | awk -F : '{print $2}' | sed "s/\s//g")
			nr_switches=$(cat /proc/$dir/sched | grep "nr_switches" | awk -F : '{print $2}' | sed "s/\s//g")
			art=$(echo "$art $nr_switches" | awk '{print $1 / $2}')
			res+=$art
			echo $res >> $file_name
			res=""
		fi
	fi
done
sort -nk 2 $file_name | awk '{print "ProcessID=" $1 " : Parent_ProcessID=" $2 " : Average_Running_Time=" $3;}' > tmp && mv tmp $file_name
