#
awk -F "," '~ /^"Jefferson"/  { print $23,$14,$12,$11}' hourly_81102_2005.csv > hourly2005.csv

awk -F "," '$23 ~ /^"Fajardo"/ { print $23,$14,$12,$11}' hourly_81102_2012.csv

# last version
awk -F "," '$23 ~ /^"Catano"/ { print $23,$14,$12,$11}' hourly_81102_2005.csv > catano2005.csv
