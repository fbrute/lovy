#!/usr/bin/Rscript --vanilla

# tidyPower.R
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
source("/home/kwabena/Documents/trafin/lovy/power/src/main/R/thtPower.R")

mainPower <- function (dbg = FALSE, mode="std", dates = "7320", GETDRY=TRUE, 
                       GETHUMID=TRUE, GETWIND=TRUE, station_name=NULL, 
                       NORMALIZE=FALSE,
                       MERGE_WITH_PM10 =TRUE, 
                       GETTHT=TRUE) {
        
        getDryPower <- function() {
            getAdiabTemps <- function (data1) {
                calcAdiabTemp <- function (T1, P1, P2) {
                    # Compute Adiabatic Temperature
                    k = 0.2857
                    T2 <- (P2 / P1)^k * (T1 + 273.15)
                    #                T2 <- (P2^k / P1) * (T1 + 273.15)
                    
                    T2 - 273.15
                }
                calcTriangleArea <- function (a=1,b=1,c=sqrt(2)) {
                    s <- 1/2 * (a + b + c)
                    sqrt(s * (s-a) * (s-b) * (s-c))
                }
                # go through all columns for same date
                temps <- numeric()
                surfs <- numeric()
                currentdate <- Sys.Date()
                triangle <- F
                for (i in 1:nrow(data1)) { 
                    #if (dbg) browser()
                    if (data1$date[i] != currentdate){
                        temps[i] <- data1$temp[i]
                        surfs[i] <- 0
                        triangle <- T
                        currentdate <- data1$date[i]
                    }
                    
                    else {
                        temps[i] = calcAdiabTemp(temps[i-1], 
                                                 data1$pressure[i-1], 
                                                 data1$pressure[i])
                        if (triangle) {
                            # side a of triangle, parallel to x axis
                            a <- abs(temps[i] - data1$temp[i])
                            
                            # side b of triangle along the sounding curve
                            b <- calcDistance(temps[i-1], data1$pressure[i-1],
                                              data1$temp[i], data1$pressure[i])
                            # side c of triangle along the adiabatic curve
                            c <- calcDistance(temps[i-1], data1$pressure[i-1],
                                              temps[i], data1$pressure[i])
                            
                            #if (dbg) browser()
                            
                            surfs[i] <- round(calcTriangleArea(a,b,c),0)
                            
                            triangle <- F} 
                        
                        else {
                            # side a,  at top of trapeze
                            a <- abs(temps[i] - data1$temp[i])
                            # size b, along the sounding curve
                            b <- calcDistance(temps[i-1], data1$pressure[i-1],
                                              data1$temp[i], data1$pressure[i])
                            # side c,  at bottom of trapeze
                            c <- abs(data1$temp[i-1] - temps[i-1])
                            # side d, along the adiabatic curve
                            d <- calcDistance(temps[i-1], data1$pressure[i-1],
                                              temps[i], data1$pressure[i])
                            h <- abs(data1$pressure[i] - data1$pressure[i-1])
                            #surfs[i] <- calcTrapezeArea(max(a,c),b,min(a,c),d)
                            surfs[i] <- round(calcTrapezeArea(a,c,h),0)
                            #                                         surf <- calcTrapezeArea(a,b,c,d)
                            #                                         
                            #                                         if (is.nan(surf))
                            #                                                 surfs[i] <- a*b
                            #                                         else
                            #                                                 surfs[i] <- surf  
                        }
                    }
                }
                #temps
                matrixadiab <- c(temps,surfs)
                dim(matrixadiab) <- c(nrow(data1),2)
                matrixadiab
            } # getAdiabTemps()
            
            #soundingdata <- getData("sounding", paramsList, dbg)
            # get data from a saved dataframe produced by tidySounging.R
            soundingdata <- dfSounding  %>%
                rename(date = dateofsounding) %>%
                filter(station_number == paramsList$station_number, 
                       date >= paramsList$start_date, 
                       date <= paramsList$end_date, 
                       pressure <= paramsList$lower_cut_pressure , 
                       pressure >= paramsList$higher_cut_pressure) %>%
                arrange(date, desc(pressure)) 
            matrixadiab <- getAdiabTemps(soundingdata)
            #matrixadiab <- getAdiabTemps(soundingRData)
            #                 temps <- getAdiabTemps(soundingdata)
            #                 surfs <- getAdiabTemps(soundingdata)
            
            if(dbg) browser()
            
            temps <- matrixadiab[,1]
            surfs <- matrixadiab[,2]
            
            soundingdata['tempadiab'] <- temps
            soundingdata['surfadiab'] <- surfs
            
            #data2 <- sqldf("select * from ")
            datelevels <- factor(soundingdata$date)
            data2 <- subset(soundingdata,select = c(date,surfadiab))
            dfs <- split(data2, datelevels)
            lapply(dfs, function(elt) sum(elt$surfadiab))
            unlist(lapply(dfs, function(elt) sum(elt$surfadiab)))
            
            powers <- as.numeric(unlist(lapply(dfs, function(elt) sum(elt$surfadiab))))
            
            df.powers <- data.frame(levels(datelevels), powers)
            
            colnames(df.powers) <- c("date", "powerdry")
            df.powers
        } # getDryPower()
        
        getThtBased <- function(colName) {
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
            #soundingdata <- getData("sounding", paramsList, dbg)
            # get data from a saved dataframe produced by tidySounging.R
            soundingdata <- dfSounding  %>%
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
            
            if(dbg) browser()
            
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
                
        } # getThtBaNsed()
            
        getHumidPower <- function() {
            getHumidTemps <- function (data1) {
                # go through all columns for same date
                temps <- numeric()
                surfs <- numeric()
                currentdate <- Sys.Date()
                for (i in 1:nrow(data1)) { 
                    #if (dbg) browser()
                    if (data1$date[i] != currentdate){
                        temps[i] <- data1$dwpt[i]
                        surfs[i] <- 0
                        triangle <- T
                        currentdate <- data1$date[i]
                    }
                    
                    else {
                        temps[i] =  data1$dwpt[i] 
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
                matrixhumid <- c(temps,surfs)
                dim(matrixhumid) <- c(nrow(data1),2)
                matrixhumid
            } #getHumidTemps()
            
            #soundingdata <- getData("sounding", paramsList, dbg)
            # get data from a saved dataframe produced by tidySounging.R
            soundingdata <- dfSounding  %>%
                rename(date = dateofsounding) %>%
                filter(station_number == paramsList$station_number, 
                    date >= paramsList$start_date, 
                    date <= paramsList$end_date, 
                    pressure <= paramsList$lower_cut_pressure , 
                    pressure >= paramsList$higher_cut_pressure) %>%
                arrange(date, desc(pressure)) 
            matrixhumid <- getHumidTemps(soundingdata)
            #matrixadiab <- getAdiabTemps(soundingRData)
            #                 temps <- getAdiabTemps(soundingdata)
            #                 surfs <- getAdiabTemps(soundingdata)
            
            if(dbg) browser()
            
            temps <- matrixhumid[,1]
            surfs <- matrixhumid[,2]
            
            soundingdata['temphumid'] <- temps
            soundingdata['surfhumid'] <- surfs
            
            #data2 <- sqldf("select * from ")
            datelevels <- factor(soundingdata$date)
            data2 <- subset(soundingdata,select = c(date,surfhumid))
            dfs <- split(data2, datelevels)
            lapply(dfs, function(elt) sum(elt$surfhumid))
            unlist(lapply(dfs, function(elt) sum(elt$surfhumid)))
            
            powers <- as.numeric(unlist(lapply(dfs, function(elt) sum(elt$surfhumid))))
            
            df.powers <- data.frame(levels(datelevels), powers)
            
            colnames(df.powers) <- c("date", "powerhumid")

            df.powers
            #ggsave(ppower, file=fname,scale=1.9)
        } # getHumidPower()
        
        getWindPower <- function() {
            #soundingdata <- getData("sounding", paramsList, dbg)
            # get data from a saved dataframe produced by tidySounging.R
            df.powers <- dfSounding  %>%
                rename(date = dateofsounding) %>%
                filter(station_number == paramsList$station_number, 
                    date >= paramsList$start_date, date <= paramsList$end_date, 
                    pressure <= paramsList$lower_cut_pressure , 
                    pressure >= paramsList$higher_cut_pressure) %>%
                mutate(wind = round(snkt/1.852/3.6),2) %>%
                group_by(date) %>%
                summarise( powerwind = round(mean(wind),2), 
                           stdpowerwind = round(sd(wind),2),
                           cape = round(mean(cape),2),
                           cape_virt = round(mean(cape_virt),2)) %>%
                select(date, powerwind, stdpowerwind, cape, cape_virt) %>%
                arrange(date) 
            
            df.powers
            #ggsave(ppower, file=fname,scale=1.9)
        } # getWindPower()
        
        normdFPower <- function(dF=NULL, fieldNames=NULL) {
            stopifnot(!is.null(dF))
            stopifnot(!is.null(fieldNames))
            stopifnot(length(fieldNames) < 1)
            dF <- getNormedDfCols(col_names = fieldNames, dF=dF, group_col="station_name")
        } 
        
        normDFPm10 <- function(dF=NULL, col_name="pm10") {
            stopif(is.null(dF))
            stopif(is.null(col_name))
            dF <- getNormedDfCol(dF, col_name = "meanpm10", group_col = "station_name")
        }
        
        paramsList = getParams()
        destination_path      <- str_glue("/home/kwabena/Documents/trafin/lovy/power/src/main/data/{paramsList$station_name}")
        stopifnot(file.exists(destination_path))
        setwd(destination_path)
        
        dfSounding <- getData(dataref = "sounding", station_name = paramsList$station_name)
        
        if (GETDRY)   dfDryPower <- getDryPower()
        if (GETHUMID) dfHumidPower <- getHumidPower()
        if (GETWIND)  dfWindPower <- getWindPower()
        if (GETTHT)  { 
            dfThtaPower <- getThtBased("thta")
            dfThtePower <- getThtBased("thte")
            dfThtvPower <- getThtBased("thtv")
        }
        if (
            all(c(GETDRY, GETHUMID, GETWIND, GETTHT)) 
            && ( nrow(dfDryPower) == nrow(dfHumidPower)  )
            && ( nrow(dfHumidPower) == nrow(dfWindPower)  )
            && ( nrow(dfWindPower) == nrow(dfThtaPower)  )
            && ( nrow(dfThtaPower) == nrow(dfThtePower)  )
            && ( nrow(dfThtePower) == nrow(dfThtvPower)  )
            && all( dfDryPower$date == dfHumidPower$date)
            && all( dfHumidPower$date == factor(dfWindPower$date) )
            && all( factor(dfWindPower$date) == dfThtaPower$date )
            && all( dfThtaPower$date == dfThtePower$date )
            && all( dfThtePower$date == dfThtvPower$date )
        ){
            dfPower <-  data.frame(dfDryPower$date, dfDryPower$powerdry, 
                                    dfHumidPower$powerhumid, dfWindPower$powerwind,
                                    dfWindPower$stdpowerwind, dfWindPower$cape, dfWindPower$cape_virt,
                                    dfThtaPower$powerthta, dfThtePower$powerthte, dfThtvPower$powerthtv )
                                    
            colnames(dfPower) <- c('date','powerdry','powerhumid','powerwind','stdpowerwind','cape', 'cape_virt')
            if (class(dfPower$date) == "factor") dfPower$date <- getDateFromFactor(fieldDateName = "date", dF = dfPower)
            dfPower$station_name <- paramsList$station_name
            dfPower <- dfPower %>%
                mutate(powerall =  (powerdry + powerhumid + powerwind)) %>%
                filter(powerdry > 1, powerhumid > 1, powerwind > 0, cape >= 0, cape_virt >=0 )
            stopifnot(nrow(dfPower) > 0)
            
            if (NORMALIZE) dfPower <- normdFPower(dF=dfPower, 
                                                  fieldNames <- c('powerdry', 
                                                                  'powerhumid',
                                                                  'powerwind',
                                                                  'cape',
                                                                  'cape_virt',
                                                                  'powerthta',
                                                                  'powerthte',
                                                                  'powerthtv'
                                                  )
                                      ) # normdFPower()
            
            # standard name before normalizing or adding pm10
            filebase=str_glue("{paramsList$station_name}_power_all")
            if (MERGE_WITH_PM10) {
                dfPm10 <- getData(dataref = "pm10", station_name = paramsList$station_name)
                stopifnot(names(dfPm10) == c("date", "pm10mean", "pm10std", "pm10nbvalues")) 
                dfPower <- merge(dfPower, dfPm10, by="date")
                stopifnot(c('pm10mean','pm10std') %in% names(dfPower))
                filebase = str_glue("{filebase}_merged_with_pm10")
            }

            #filebase=str_glue("{paramsList$station_name}_power_all")
            save(dfPower, file=str_glue("{filebase}.RData"))
            write.csv(dfPower, file=str_glue("{filebase}.csv"))
        }
} # mainPower()

#################################### Run main function ##################################
# mainPower(station_name = "pr")
#################################### Run main function ##################################