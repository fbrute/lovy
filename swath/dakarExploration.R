setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")
source("utils.R")

getDakarModis <- function (julianDay, algo) 
{
    LONGITUDE = "Longitude"
    LATITUDE  = "Latitude"
    
    if (algo == 'O')  
    {
        AOTMODIS = "Effective_Optical_Depth_Average_Ocean"
    }
    
    if (algo == 'L')  
    {
        AOTMODIS = "Corrective_Optical_Depth_Land"
    } 
    
    if (algo == 'LAO')  
    {
        AOTMODIS = "Optical_Depth_Land_And_Ocean"
    }
    fixnum = 6
    
    north = 16
    south = 12
    
    west = - 20
    east = - 16
    
    data_path =  "/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath/csv550"
    
    latitude = getDataframeFromMultipleCsv ( get_csv_filenames(data_path, LATITUDE, julianDay), LATITUDE )
    longitude = getDataframeFromMultipleCsv( get_csv_filenames(data_path, LONGITUDE, julianDay), LONGITUDE )
    aotModis = getDataframeFromMultipleCsv( get_csv_filenames(data_path, AOTMODIS, julianDay), AOTMODIS )
    
    idxlat  = which(latitude >= south & latitude <= north)
    idxlong  = which(longitude >= west & longitude <= east)
    idxswath = intersect(idxlat, idxlong)
    
    latitude = latitude[idxswath]
    latitude = round(latitude,4)
    
    longitude = longitude[idxswath]
    longitude = round(longitude,4)
    
    aotModis = aotModis[idxswath]/1000
    aotModis = signif(aotModis,fixnum)
    
    dfDakar = na.omit(data.frame(latitude, longitude, aotModis))
}

mainDakar <- function () 
{
    lovyDates = c("2/25/2015",
        "4/09/2015",
        "4/30/2015",
        "5/1/2015",
        "5/9/2015",
        "5/12/2015",
        "5/16/2015",
        "5/17/2015",
        "5/23/2015",
        "6/4/2015",
        "6/7/2015",
        "6/8/2015",
        "6/10/2015",
        "6/11/2015",
        "6/14/2015",
        "6/18/2015",
        "6/19/2015",
        "6/20/2015",
        "6/21/2015",
        "6/23/2015",
        "6/25/2015",
        "6/26/2015",
        "6/27/2015",
        "6/28/2015",
        "7/3/2015",
        "7/4/2015",
        "7/6/2015",
        "7/7/2015",
        "7/11/2015",
        "7/14/2015",
        "7/17/2015",
        "7/18/2015",
        "7/20/2015",
        "7/21/2015",
        "7/26/2015",
        "7/27/2015",
        "8/10/2015",
        "8/20/2015",
        "8/24/2015",
        "8/26/2015",
        "9/9/2015")
    
    require(lubridate)
    for (dDate in lovyDates) 
    {
        julianDay = yday(mdy(dDate))
        print(julianDay)
        dfDakar = getDakarModis(julianDay)
        plotDakar(dfDakar, julianDay, dDate)
    }
}    

mainDakarByDate <- function (mainDate) 
{
 
    require(lubridate)
        julianDay = yday(mdy(mainDate))
        print(julianDay)
        #dfDakarOcean = getDakarModis(julianDay, 'O')
        #dfDakarLand = getDakarModis(julianDay,  'L')
        dfDakarLandAndOcean = getDakarModis(julianDay,  'LAO')
        plotDakar(dfDakarLandAndOcean, julianDay, mainDate)
} 