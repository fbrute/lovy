#!/usr/bin/env 
# France-Nor Brute January 2017
#
# Used to prepare data from pm10 gwadair excel files,  before being imported by mysqlimport 
#
# Check first if date format is correct at midnight while checking in excel

# Get dates to ymd format, and add 0 seconds to time
# ok for 2013,2014 and 2015 first semester
#s_([0-9]+)/([0-9]+)/([0-9]+) ([0-9]+):([0-9]+)_\3-\2-\1 \4:\5:00_

# Get dates to ymd format, and add 0 seconds to time
##############################################
# special treatment for 2015 second semester
##############################################

#s_([0-9]+)/([0-9]+)/([0-9]+) ([0-9]+):([0-9]+)_\3-\2-\1 \4:\5:00_

# separate date from time
s_([0-9]+)/([0-9]+)/([0-9]+) ([0-9]+):([0-9]+)_\3-\2-\1;\4_

#s_([0-9]+)/([0-9]+)/([0-9]+) ([0-9]+):00_\3-\2-\1 \4:00_
#s_([0-9]+)/([0-9]+)/([0-9]+)_\3-\2-\1_
#
##############################################
# special treatment for 2016 with daily values only
# and special files 2016.csv already provided by lov
# and dates already formatted thru vim
##############################################
#s_(;)_ 12:00:00;_

##############################################
# special treatment for 2017 with daily values only
##############################################
#s_([0-9]+)/([0-9]+)/([0-9]+)_\3-\2-\1 12:00:00_

# set the missing values;
#s/(;;;;;;;;;;;)/;-999.9/

# get rid of extras ;
#s/;+//

# transform decimal separator ',' to '.'
s/,/./
