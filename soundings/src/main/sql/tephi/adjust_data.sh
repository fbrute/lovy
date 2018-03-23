#!/usr/bin/env bash

# Execute all sql files in the current directory
for sql_file in  `ls *.sql` ; do mysql -u dbmeteodb --password=dbmeteodb dbmeteodb < $sql_file > ${sql_file%%*.*}.txt ; done;

# Add a # at the beginning of the first line of every text 
for data_file in  `ls *.txt` ; do sed -E -i txt.bak '1 s/^/#/' ${data_file%%.*}.txt ; done;
