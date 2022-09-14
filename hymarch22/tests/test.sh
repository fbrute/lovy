#!/bin/ksh

where=$1
echo $where

if ! [[ $where = 'karu' || $where = 'mada' || $where = 'barb' ]]; then
  echo Please check the name of the file wich should contain karu or mada  or puer or barb at the beginning 
  exit
fi