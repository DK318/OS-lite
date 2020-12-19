#!/bin/bash

crontab -l > tmp
echo "*/5 * * * 3 ~/OS-lite/Lab3/task1.sh" >> tmp
cat tmp | crontab
rm -f tmp
