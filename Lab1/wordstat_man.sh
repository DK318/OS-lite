#!/bin/bash

man bash | grep -oi "[a-zA-Z]\{4,\}" | tr "[:upper:]" "[:lower:]" | sort | uniq -c | sort -rn | head -3
