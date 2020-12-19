#!/bin/bash

if [[ !(-d ~/source) ]]; then
    echo "There is no source directory ($HOME/source)"
    exit 1  
fi

make_new=1
cur_dir=$HOME
now_date=$(date +"%Y-%m-%d")
log_renamed=""

for cur in $(ls -d "$HOME/Backup-"????"-"??"-"?? 2> /dev/null); do
    if [[ -d $cur ]]; then
        cur_date=$(echo "$cur" | grep -o "[[:digit:]]\{4\}-[[:digit:]]\{2\}-[[:digit:]]\{2\}")
        
        
        if [[ -z "$cur_date" ]]; then
            continue
        fi
        
        cur_seconds=$(date +"%s" -d "$cur_date" 2> /dev/null)
        
        if [[ $? != 0 ]]; then
            continue
        fi
        
        now_seconds=$(date +"%s")
        
        if (( "$now_seconds" - "$cur_seconds" < 60 * 60 * 24 * 7 )); then
            cur_dir=$cur
            make_new=0
            break
        fi
    fi
done

if [[ "$cur_dir" == "$HOME" ]]; then
    cur_dir="$HOME/Backup-$now_date"
    mkdir "$cur_dir"
fi

run_dir=$(pwd)
cd ~/surce
for file_path in $(find -type f); do
    relative_path="${file_path:1}"
    if [[ -f "$cur_dir$relative_path" ]]; then
        if (( $(stat -c%s ~/source$relative_path) != $(stat -c%s "$cur_dir$relative_path") )); then
            mv "$cur_dir$relative_path" "$cur_dir$relative_path.$now_date"
            cp "$HOME/source$relative_path" "$cur_dir$relative_path"
            log_renamed+="$file_path renamed to $file_path.$now_date\n"
        fi
    else
        log_new+="$file_path\n"
    fi
    
    cp --parents "$file_path" "$cur_dir"
done
cd "$run_dir"

echo -e "-----------------\n" >> ~/backup-report

if [[ "$make_new" == "1" ]]; then
    echo -e "($now_date) New backup directory was created Backup-$now_date\n" >> ~/backup-report
else
    echo -e "($now_date) Exsisting backup directory $cur_dir was changed\n" >> ~/backup-report
fi

if [[ -n "$log_new" ]]; then
    echo -e "New files added\n" >> ~/backup-report
    echo -e "$log_new" >> ~/backup-report
fi

if [[ -n "$log_renamed" ]]; then
    echo -e "Files changed\n" >> ~/backup-report
    echo -e "$log_renamed" >> ~/backup-report 
fi
