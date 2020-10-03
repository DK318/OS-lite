#!/bin/bash

file_name="cpu_burst.log"
cnt=1
cur_ppid=$(cat $file_name | awk -F : 'NR==1{print $2}' | sed "s/ Parent_ProcessID=//" | sed "s/\s//g")
sum_art=$(cat $file_name | awk -F : 'NR==1{print $3}' | sed "s/ Average_Running_Time=//")
cat $file_name | awk 'NR==1{print $0}' > tmp
ppids=$(cat $file_name | awk -F : '{print $2}' | sed "s/ Parent_ProcessID=//" | sed "s/\s//g" | tail -n +2)
line=2
for ppid in $ppids
do
	if [[ $ppid != $cur_ppid ]]; then
		if [[ $sum_art == .* ]]; then
			sum_art=0$sum_art
		fi
		sum_art=$(echo $sum_art | tr '.' ',')
		avg=$(echo "$sum_art $cnt" | awk '{print $1 / $2;}')
		echo "Average_Sleeping_Children_of_ParentID=$cur_ppid is $avg" >> tmp
		cnt=1
		sum_art=$(cat $file_name | awk -F : -v line="$line" 'NR==line{print $3}' | sed "s/ Average_Running_Time=//")
		cur_ppid=$ppid
	else
		sum_art=$(echo $sum_art+$(cat $file_name | awk -F : -v line="$line" 'NR==line{print $3}' | sed "s/ Average_Running_Time=//") | tr ',' '.' | bc)
		let cnt=$cnt+1
	fi
	cat $file_name | awk -v line="$line" 'NR==line{print $0}' >> tmp
	let line=$line+1
done
if [[ $sum_art == .* ]]; then
	sum_art=0$sum_art
fi
sum_art=$(echo $sum_art | tr '.' ',')
avg=$(echo $sum_art $cnt | awk '{print $1 / $2;}')
echo "Average_Sleeping_Children_of_ParentID=$cur_ppid is $avg" >> tmp
mv tmp $file_name
