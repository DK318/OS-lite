#!/bin/bash

file_to_delete="$1"

if [[ "$#" -ne "1" ]]; then
	echo "Usage: ./rmtrash <file_to_delete>"
	exit 1
fi

if [[ "$file_to_delete" =~ .*/.* ]]; then
	echo "File name can't contain slashes"
	exit 1
fi

if [[ !(-f "$file_to_delete") ]]; then
	echo "File not exists"
	exit 1
fi

if [[ !(-d ~/.trash) ]]; then
	mkdir ~/.trash
fi

if [[ !(-f ~/.trash/.next) ]]; then
	echo "0" > ~/.trash/.next
fi

next=$(cat ~/.trash/.next)
let next=next+1
echo "$next" > ~/.trash/.next

ln "$file_to_delete" ~/.trash/$next
rm "$file_to_delete"

echo "$next$PWD/$file_to_delete" >> ~/.trash.log
echo "File was successfully deleted"
