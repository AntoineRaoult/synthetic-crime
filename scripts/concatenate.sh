#!/bin/bash

script=concat.R

echo "library(here)" > $script

for file in $(ls ../script2-data)
do
    echo "load(here(\"script2-data\", \"$file\"))" >> $script
    echo "$(echo "$file" | cut -d "." -f1) <- syn_res_OA" >> $script
done

echo -n "total <- rbind(" >> $script

for file in $(ls ../script2-data)
do
        echo -n "$(echo "$file" | cut -d "." -f1)," >> $script
done

truncate -s -1 $script

echo ")" >> $script 

echo "save(total, file = here(\".\", \"total\"))" >> $script
