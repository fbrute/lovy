#!/usr/bin/env bash

echo $1
input_file=$1

# delete 2014
#mysql -u dbmeteodb --password=dbmeteodb -e 'delete from pm10 where year(datetime)=2014' dbmeteodb


# prepare data to be imported to mysql
sed -E -f format_aeronet.sed < $input_file > aeronet1.txt


# get rid of leading carriage return of sed
tr -d '\r'  < aeronet1.txt > aeronet.txt

#mv pm10_3.csv $1 

#mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' -c datetime,jour,pmptp dbmeteodb pm10.csv

##############################################
# special treatment for 2015 second semester, no jour column
##############################################
#mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' -c date,pm10 dbmeteodb $1 

mysql -u dbmeteodb --password=dbmeteodb dbmeteodb -e "load data infile '~/lovy/data/aeronet/aeronet.txt' into table aotsanjuan fields terminated by ',' ignore 5 lines" 

