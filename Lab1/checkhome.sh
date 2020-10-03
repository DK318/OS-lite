#!/bin/bash

if [[ "$PWD" == "$HOME" ]]; then
  echo "$HOME"
  exit 0
else
  echo "Something went wrong"
  exit 1
fi
