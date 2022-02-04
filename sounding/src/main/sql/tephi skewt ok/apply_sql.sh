#!/bin/bash

for file in `ls *.sql`; do
    #echo $file
    #echo "${file%%.*}"
    basename="${file%%.*}"
    echo $file
    output_filename=${basename}.txt
    `mysql -u dbmeteodb --password=dbmeteodb dbmeteodb`
done


