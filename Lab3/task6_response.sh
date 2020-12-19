#!/bin/bash

echo $$ > .pid
var=1
mode="work"
op="+"
usr1()
{
	op="+"
}
usr2()
{
	op="*"
}
term()
{
	mode="stop"
}
sigtrap()
{
	op="-"
}
trap "usr1" USR1
trap "usr2" USR2
trap "term" SIGTERM
trap "sigtrap" SIGTRAP
while true; do
	if [[ "$mode" == "work" ]]; then
		var=$(echo "$var $op 2" | bc)
		echo "$var"
	else
		echo "SIGTERM"
		exit
	fi
	sleep 1
done
