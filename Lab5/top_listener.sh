#!/bin/bash

while true; do
    top -bn 1 | head -12 >> top_report
    sleep 10
done
