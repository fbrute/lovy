#!/bin/ksh
files=`ls test_scenario`
print $files
for file in $files; do
  print $file
done
