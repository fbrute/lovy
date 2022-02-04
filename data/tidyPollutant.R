# Copyright 2021
# France-Nor Brute
#
# Written for KaruSphere
# All rights reserved
# 
# Import pollutants from a country and merge to get a unique dataframe, to wrangle and deliver to Lovy 

library(stringr) # provides str_to_title ~ toUpcase
library(lubridate)
library(dplyr)

mainPollutant <- function(station="pr", pollutants=c("pb"), useCache = TRUE) { 
    
    main <- function(pollutants) {
        lapply(pollutants, FUN=mainForEachPollutant)
    }
    
    getDataFramePollutantForOneYear <- function(file ="") {
        data_frame_for_one_year = read.csv(file=file, stringsAsFactors = FALSE)
        data_frame_for_one_year$Date = mdy(data_frame_for_one_year$Date)
        data_frame_for_one_year
    }
    
    getColumnNamesForDataFramePollutantForOneYear <- function(file="") {
        data_frame = read.csv(file=file, stringsAsFactors = FALSE)
        colnames(data_frame)
    }
    
    mainForEachPollutant <- function(pollutant) {
        path_to_data <- str_glue("/home/kwabena/Documents/trafin/lovy/data/{station}AirNow/airNow{str_to_title(pollutant)}")
        setwd(path_to_data)
        files <- Sys.glob("*.csv")
        firstFile = files[1]
        colnames <- getColumnNamesForDataFramePollutantForOneYear(firstFile)
        # Initialize result data frame with a data frame for the first year
        dataFrameResults <- getDataFramePollutantForOneYear(firstFile)
        # Get and merge pollutant for other years
        for (i in 2:length(files))   {
            dataFrameForOneYear <- getDataFramePollutantForOneYear(files[i])
            #dataFrameResults <- merge(dataFrameResults, dataFrameForOneYear, all.x = TRUE, all.y = TRUE)
            dataFrameResults <- merge(dataFrameResults, dataFrameForOneYear, all =TRUE)
        }
        
        mainValueName <- eval(colnames[5])
        meanColumnName <- str_glue("mean{str_to_title(pollutant)}")
        
        dataFrameResults %>%
            group_by(Date) %>%
            summarize(mean = round(mean(.data[[mainValueName]]),2),
                      std = round(sd(.data[[mainValueName]]),2),
                      nbValues = n()
            ) %>%
            mutate() %>%
            write.csv(file= str_glue("{str_to_title(station)}{str_to_title(pollutant)}.csv"),
                  row.names = FALSE)
    }
    # Execute for all pollutants
    main(pollutants)
}