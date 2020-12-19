#!/bin/bash

if [[ "$#" -ne "1" ]]; then
    echo "Usage: ./untrash.sh <file_to_restore>"
    exit 1
fi

if [[ !(-d ~/.trash) ]]; then
    echo "Trash bin is not exists"
    exit 1
fi

file_to_restore="$1"
if [[ "$file_to_restore" =~ .*/.* ]]; then
    echo "File name can't contain slashes"
    exit 1
fi

if [[ !(-f ~/.trash.log) ]]; then
    echo "trash.log doesn't exist"
    exit 1
fi

lines=$(cat ~/.trash.log | wc -l)

for ((i=1; i<=$lines; i++)); do
    line=$(cat ~/.trash.log | awk -v line="$i" 'NR==line{print $0}')
    path=$(echo "$line" | awk -F "/" '{tmp="/"; for(i=2; i<=NF; i++) tmp=tmp"/"$i; print tmp}')
    link_number=$(echo "$line" | awk -F "/" '{print $1}')
    file_name=$(echo "$path" | awk -F "/" '{print $NF}')
    
    if [[ "$file_name" == "$file_to_restore" ]]; then
        if [[ !(-f ~/.trash/$link_number) ]]; then
            continue
        fi
        
        while true; do
            echo "Restore $file_name to $path? (Y/N)"
            read response
            case "$response" in
                "Y")
                    restore=1
                    break
                    ;;
                "N")
                    restore=0
                    break
                    ;;
                *)
                    ;;
            esac
        done
        
        if [[ "$restore" -eq 0 ]]; then
            continue
        fi
        
        echo "Trying to reset file $file_name to $path"
        ln ~/.trash/$link_number $path 2> /dev/null
        if [[ $? != 0 ]]; then
            echo "Can't restore in $path. File will restore at home directory"
            ln ~/.trash/$link_number ~/$file_name 2> /dev/null
            if [[ $? != 0 ]]; then
                echo "Can't restore in home directory."
                
                while true; do
                    echo "Change file name: "
                    read new_name
                    
                    if [[ "$new_name" =~ .*/.* ]]; then
                        echo "File name can't contain slashes"
                        continue
                    fi
                    
                    if [[ -f ~/$new_name ]]; then
                        echo "File with name $new_name exists"
                        continue
                    fi
                    
                    break
                done
                
                ln ~/.trash/$link_number ~/$new_name
            fi
        fi
        rm ~/.trash/$link_number
        echo "File was successfully restored"
        break
    fi
done

if [[ "$restore" != "1" ]]; then
    echo "Nothing was restored" 
fi
