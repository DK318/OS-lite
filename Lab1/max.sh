#!/bin/bash

if [[ -z "$3" || -n "$4" ]]; then
  echo "Usage: ./max.sh 'first' 'second' 'third'"
  exit
fi
for var in $1 $2 $3
do
  if ! [[ $var =~ ^-?[1-9][0-9]*$ || $var = "0" ]]; then
    echo "Arguments must be numbers and without leading zeros"
    exit
  fi
done
if [[ $1 -gt $2 && $1 -gt $3 ]]; then
  echo $1
elif [[ $2 -gt $1 && $2 -gt $3 ]]; then
  echo $2
else
  echo $3
fi
