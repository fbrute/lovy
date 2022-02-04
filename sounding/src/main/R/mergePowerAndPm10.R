#!/usr/bin/Rscript
#
# France-Nor Brute for Karusphere
# Copyright 2021
# All rights reserved


library(stringr)
main <- function(station_name)  {
    
    mergePowerAndPm10 <- function(station_name="pr", path=NULL) {
        getPower() <- function() {
            file_name <- str_glue("{path_to_data}/{station_name}_power_all.RData")
            stopifnot( file.exists(file_name))
            df_name <- str_glue("df_for_all_{paramsList$station_name}")
            load( file_name)
            dfPower <- get(x=df_name)
        }
        
        getPm10() <- function() {
        
            
        }
        
        path_to_data = str_glue("/home/kwabena/Documents/trafin/lovy/soundings/src/main/data/{station_name}")
        setwd(path_to_data)
        dfPower <- getPower()
        dfPm10 <- getPm10()
        
        dfPowerAndPm10
    } #mergePowerAndPm10()
} #main()