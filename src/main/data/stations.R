# Names of stations studied
#
library(tidyverse)
mainStations <- function () {
     list_stations <- list( 
                            list(station_name="barbade",            station_number = 78954) , 
                            list(station_name="pr",                 station_number = 78527),
                            list(station_name="tenerife",           station_number = 60018),
                            list(staiton_name="dakhla",             station_number = 60096), 
                            list(station_name="santodomingo",       station_number = 78486),
                            list(station_name="saintmarteen",       station_number = 78866)
                          )
    
    dfStations <- Reduce(x = list_stations, f= rbind, init=NULL)
    setwd("/home/kwabena/Documents/trafin/lovy/src/main/data/")
    save( dfStations, file="dfStations.RData")   
}
