#!/bin/bash

mkdir test && {
	echo "catalog test was created successfully" >> ~/report
	start_time=$(ps ax -o pid,start | sed "s/\s*//" | grep "$$" | awk '{print $2}')
	file_name=$(date +"%m-%d-%y")" $start_time"
	touch "$file_name"
}
ping "www.net_nikogo.ru" 2 > /dev/null || {
	echo $(date) "can't reach www.net_nikogo.ru" >> ~/report
}
