#1/bin/bash

if [[ !(-d ~/restore) ]]; then
    mkdir ~/restore
fi

cur_dir="$HOME"
max_time=0

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
        
        if (( "$cur_seconds" > "$max_time" )); then
            cur_dir=$cur
            max_time=$cur_seconds
            break
        fi
    fi
done

if [[ "$cur_dir" == "$HOME" ]]; then
    echo "There is no backups"
    exit 0
fi

run_dir=$(pwd)
cd "$cur_dir"
for file in $(find -type f); do
    relative_path="${file:1}"
    if [[ ! "$relative_path" =~ .*\.[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$ ]]; then
        cp --parents "$file" ~/restore
    fi
done
cd "$run_dir"

echo "Successfully upbacked"
