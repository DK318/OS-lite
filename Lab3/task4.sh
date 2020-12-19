#!/bin/bash

cpulimit -l 10 ./task4_loop.sh&
./task4_loop.sh&
./task4_loop.sh&
