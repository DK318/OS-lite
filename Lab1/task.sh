#!/bin/bash

if [[ "$#" -ne 12 ]]; then
	echo "There must be only 12 arguments"
	exit
fi
for arg in $@
do
	let res=$arg*$RANDOM
	echo "Обработка параметра $arg дала $res"
done
