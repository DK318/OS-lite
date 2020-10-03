#!/bin/bash

cat /var/log/syslog | awk '{if ($6 = "<info>") print $0}' > info.log
