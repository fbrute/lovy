plotDakar <- function (dfDakarLandAndOcean , julianDay, Date) {
    library(ggmap) 
    # plot a map with modis aot around dakar
    # West = -20, East = -16
    # North = 16, South = 12
    
    # location is around dakar, we use the center of above limits
    dakar <- c(-18,14)
    
    # df is the grid containing lat & lon
    #df <- expand.grid(x = seq(-16.0,-20,by=-0.05) , y= seq(12, 16, by=0.05 ))
    
    # aot using random normal distribution
    #df$aot = rnorm(nrow(df), 0.5, 0.14)
    
    #get the initial map
    library(lubridate)
    #dateWithTimeFromJulianDay = strptime(paste("2015",julianDay,sep=''), "%Y%j", tz="UTC")
    dakarMapInit <- qmap(location = dakar, zoom =8, color = 'bw') + ggtitle(paste("Dakar", Date))
    #dakarMapInit <- qmap(location = dakar, zoom =8)
    
    # the color is expected to reflect the aot value
    dakarMap <- dakarMapInit + geom_point(aes(x = longitude , y = latitude, colour = aotModis), data = dfDakarLandAndOcean)
    dakarMap <- dakarMap + scale_color_gradient(low="blue", high="red")
    
    print(dakarMap)
    ggsave(dakarMap, file=paste( "dakar_lao_", julianDay, ".pdf", sep =""))
    
    #dakarMap <- dakarMapInit + stat_bin2d(aes(x , y, colour = aot, fill = aot), size = .001, bins = 100, alpha = 1/2, data = df)
    #print(dakarMap)
    
}

