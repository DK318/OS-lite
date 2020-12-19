#!/bin/bash

if [[ -f $PWD/max.log ]]; then
	rm -f $PWD/max.log
fi
pids=$(ps ax -o pid | sed "s/\s*//" | head -n -4 | tail -n +2)
for pid in $pids
do
	if [[ -d /proc/$pid/  ]]; then
		bytes=$(cat /proc/$pid/io | grep "read_bytes:" | awk '{print $2}')
		echo "$pid $bytes" >> tmp
	fi
done
sleep 10s
line=1
for pid in $pids
do
	if [[ -d /proc/$pid/ ]]; then
		cur_bytes=$(sudo cat /proc/$pid/io | grep "read_bytes:" | awk '{print $2}')
		prev_bytes=$(cat tmp | awk -v line="$line" 'NR==line{print $2}')
		if [[ $prev_bytes =~ ^[0-9]+$ ]]; then
			let cur_bytes=$cur_bytes-$prev_bytes
			echo "$pid $cur_bytes" >> tmp1
		fi
	fi
	let line=$line+1
done
mv tmp1 tmp
sort -nk 2 -r tmp > tmp1 && mv tmp1 tmp
cat tmp | head -n 3 > tmp1 && mv tmp1 tmp
for proc in 1 2 3
do
	pid=$(awk -v line="$proc" 'NR==line{print $1}' tmp)
	cmd=$(ps ax -o pid,cmd | sed "s/\s*//" | grep -E "^$pid\s" | awk '{print $2}')
	bytes=$(awk -v line="$proc" 'NR==line{print $2}' tmp)
	echo "$pid:$cmd:$bytes" >> max.log
done
rm -f tmp
