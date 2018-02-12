#!/usr/bin/env bash

echo $1
input_file=$1

#create table pm10madalovhoraire (idx int not null, datetime datetime not null, pm10 decimal(4,1));
#alter table pm10madalovhoraire add primary key (idx);

#create table pm10madalovhoraire (idx int auto_increment primary key, date date not null,hour int(2), pm10 decimal(4,1));

# delete 2014
#mysql -u dbmeteodb --password=dbmeteodb -e 'delete from pm10 where year(datetime)=2014' dbmeteodb


# prepare data to be imported to mysql
sed -E -f format_pm10.sed < $input_file > pm10_2.csv


# get rid of leading carriage return of sed
tr -d '\r'  < pm10_2.csv > pm10_3.csv

mv pm10_3.csv $1 

#mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' -c datetime,jour,pmptp dbmeteodb pm10.csv

##############################################
# special treatment for 2015 second semester, no jour column
##############################################
#mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' -c date,pm10 dbmeteodb $1 
#mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' -c date,hour,pm10 dbmeteodb $1 
mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=';' --ignore-lines=1 -c date,hour,pm10 dbmeteodb $1 
