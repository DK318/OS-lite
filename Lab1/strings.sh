#!/bin/bash

read cur
while [[ "$cur" != "q" ]]
do
  buf+="$cur"
  read cur
done
echo "$buf"
