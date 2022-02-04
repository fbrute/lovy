# thtPower.R
#
# get Power indice usings THT last 3 columns of a sounding
#
# Paramètres initiaux de coupure
# 850 hPa pour environ 1500m
# 700 hPa pour environ 3000m

library(DBI)
library(stringr)
library(tidyverse)

# provide getData for pm10 or sounding
source("/home/kwabena/Documents/trafin/lovy/src/main/R/utils.R")
source("/home/kwabena/Documents/trafin/lovy/power/src/main/R/utilsPower.R")

# get Power indice usings THT last 3 columns of a sounding
getThtTemps <- function(data1) {
    stopifnot(colName %in% c("thta","thtv","thte") ) 
    # go through all columns for same date
    temps <- numeric()
    surfs <- numeric()
    currentdate <- Sys.Date()
    for (i in 1:nrow(data1)) { 
        #if (dbg) browser()
        if (data1$date[i] != currentdate){
            #temps[i] <- data1$dwpt[i]
            temps[i] <- convertTempFromKelvinToCelsius(unlist(data1[colName])[i])
            surfs[i] <- 0
            triangle <- T
            currentdate <- data1$date[i]
        }
        
        else {
            #temps[i] =  data1$dwpt[i] 
            temps[i] <- convertTempFromKelvinToCelsius( unlist(data1[colName])[i] )
            # side a,  at top of trapeze
            #a <- abs(temps[i] - data1$temp[i])
            # Take true difference, deviation from getDryTemps 
            a <- data1$temp[i] - temps[i]
            # side c,  at bottom of trapeze
            # Take true difference, deviation from getDryTemps 
            c <- data1$temp[i-1] - temps[i-1]
            h <- abs(data1$pressure[i] - data1$pressure[i-1])
            
            surfs[i] <- round(calcTrapezeArea(a,c,h),0)
        }
    }
    #temps
    matrixtht <- c(temps,surfs)
    dim(matrixtht) <- c(nrow(data1),2)
    matrixtht
} #getThtTemps()

getThtBased <- function(paramsList, soundingdata, colName) {
     #getThtTemps()
    #soundingdata <- getData("sounding", paramsList, dbg)
    # get data from a saved dataframe produced by tidySounging.R
    soundingdata <- soundingdata  %>%
        rename(date = dateofsounding) %>%
        filter(station_number == paramsList$station_number, 
               date >= paramsList$start_date, 
               date <= paramsList$end_date, 
               pressure <= paramsList$lower_cut_pressure , 
               pressure >= paramsList$higher_cut_pressure) %>%
        arrange(date, desc(pressure)) 
    matrixtht <- getThtTemps(soundingdata)
    #matrixadiab <- getAdiabTemps(soundingRData)
    #                 temps <- getAdiabTemps(soundingdata)
    #                 surfs <- getAdiabTemps(soundingdata)
    
    temps <- matrixtht[,1]
    surfs <- matrixtht[,2]
    
    soundingdata['temptht'] <- temps
    soundingdata['surftht'] <- surfs
    
    #data2 <- sqldf("select * from ")
    datelevels <- factor(soundingdata$date)
    data2 <- subset(soundingdata,select = c(date,surftht))
    dfs <- split(data2, datelevels)
    lapply(dfs, function(elt) sum(elt$surftht))
    unlist(lapply(dfs, function(elt) sum(elt$surftht)))
    
    powers <- as.numeric(unlist(lapply(dfs, function(elt) sum(elt$surftht))))
    
    df.powers <- data.frame(levels(datelevels), powers)
    df.powers <- data.frame(levels(datelevels), powers)
    
    colnames(df.powers) <- c("date", str_glue("power{colName}"))
    
    df.powers
    #ggsave(ppower, file=fname,scale=1.9)
    
} # getThtBa