# Copyright 2021
# Written for KaruSphere
# All rights reserved
# 
# Import pollutants from different contries into dbmeteodbo

library(RMariaDB)
library(stringr) # provides str_to_title ~ toUpcase

mainPollutant <- function(station="pr", pollutant="so2")
    
    path_to_data <- str_glue("/home/kwabena/Documents/trafin/lovy/data/{station}AirNow/airNow{str_to_title(pollutant)}")
    setwd(path_to_data)
    
    addDataFrameToMariaDB <- function(file ="") {
        data_frame = read.csv(file=file, stringsAsFactors = FALSE)
        data_frame$Date = MDYToYMD(data_frame$Date)
        pollutant_to_downcase = str_to_lower(pollutant)
        table_name <- str_glue(station, pollutant_to_downcase)
        dbWriteTable(con, table_name, data_frame, append=T)
    }
    
    MDYToYMD <- function(date) {
        year <- substr(date,7,10)
        month <- substr(date,1,2)
        day <- substr(date,4,5)
        paste(year,month,day, sep="-")
    }
    
    files <- Sys.glob("*.csv")
    
    con <- dbConnect(RMariaDB::MariaDB(),  
                     user="dbmeteodb", 
                     password="dbmeteodb",
                     dbname="dbmeteodb",
                     host="localhost")
    
    tryCatch(
        { 
            #create table prpm10
            #system(str_glue("cat ./create_table_",pollutant,".sql | mariadb -udbmeteodb -pdbmeteodb dbmeteodb"))
            # add csv file to dbmeteodb
            lapply(files, FUN=addDataFrameToMariaDB)
            # read and export data to csv file
        },
        finally = { dbDisconnect(con) }
    )
}