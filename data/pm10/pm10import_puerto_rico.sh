#
#awk -F "," '~ /^"Jefferson"/  { print $23,$14,$12,$11}' hourly_81102_2005.csv > hourly2005.csv

#awk -F "," '$23 ~ /^"Fajardo"/ { print $23,$14,$12,$11}' hourly_81102_2012.csv

# last version
awk -F "," '$23 ~ /^"Catano"/ { print $23,$12,$11,$14}' hourly_81102_2005.csv > pm10_catano.csv

mysql -u dbmeteodb --password=dbmeteodb dbmeteodb -e "drop table pm10_catano; create table pm10_catano  (date date not null, hour int(2) not null, constraint pk_pm10 primary key(date,hour), pm10 decimal(4) not null)"

mysqlimport --local -u dbmeteodb --password=dbmeteodb --fields-terminated-by=' ' -c date,hour,pm10 dbmeteodb pm10_catano.csv

