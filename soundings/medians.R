getProfileQueryString <- function(period, season, dustClass) {
    if (length(period) < 2) stop ("Wrong number of dates for period")
    #stopifnot(length(period) == 2)
    
    getSkeleton <- function() {
    }
    
    getMeansQueryString <- function() {
        
    }
}

simulation <- function (period, season, step, dustCuts) {
    if (missing(period)) stop("Please specify a period")
    if (missing(season)) stop("Please specify a season")
    
    if (length(period) < 2) stop ("Wrong number of dates for period")
    
    okstringforlov = "select sounding1.date, pressure , temp , pm10 from sounding1 , (select date(datetime) as date , avg(pmptp) as pm10 from pm10 group by date) as pm10avg where sounding1.date between '2012-06-01' and '2012-06-02' and sounding1.date = pm10avg.date order by date"
    
    buildQueryString <- function() {
         
        getSoundingAndPm10ByDateSqlString <- function() {
                
            paste(
                "select sounding1.date, cape, cins, pressure , temp , mixr, relhumidity, snkt as windspeed, drct as wind_direction , pm10 from",
                    "sounding1" ,",",
                    "(select date(datetime) as date , avg(pmptp) as pm10 from pm10 group by date) as pm10avg",
                    "where sounding1.date between", period$startDate, "and", period$endDate,
                        "and time = '12:00:00'",
                        "and sounding1.date = pm10avg.date order by date;"
            )
            
        }
        
    }
    
    getData <-function () {
        
    }
}

simulationObject <- function (period, months, step, dustCuts) {
}

main <- function (startDate = "'2005-01-01'", endDate = "'2015-12-31'", month=6, step=25, minPressure = 50, maxPressure = 1020, time = "'12:00:00'") {
    
    getProfileForLowSeasonQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed, pm10", 
                "from (select date, floor(pressure /",
                step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
                    "from sounding1",
                    "where date not in (select date from ex_dates_sounding) and year(date) between year(", startDate, ") and year(",endDate, ") and month(date) in (1,2,12) and time =", time ,
                    "and pressure between" ,minPressure, "and", maxPressure ,
                        "group by date, index_number) as meanProfiles",
                        "left join",
                    "(select date(datetime) as date , avg(pmptp) as pm10 from pm10" ,
                    "group by date) as pm10avg",
                "on (pm10avg.date = meanProfiles.date);"
        )
    }
    
    getProfilesForLowSeasonWithPm10QueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from", 
            "(select floor(pressure /", step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from", 
            "sounding1" , 
            "where sounding1.date not in (select date from ex_dates_sounding)",
            "and year(sounding1.date) between year(", startDate, ") and year(",endDate, ")" ,
            "and month(sounding1.date)", "in (1,2,12)", 
            "and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure,
            "group by index_number) as meanprofiles;"
        )
    }
    
    getProfileForLowSeasonWithHighDustQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from", 
            "(select floor(pressure /", step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from", 
            "sounding1" , 
            "where sounding1.date not in (select date from ex_dates_sounding)",
            "and year(sounding1.date) between year(", startDate, ") and year(",endDate, ")" ,
            "and month(sounding1.date)", "in (1,2,12)", 
            "and sounding1.date in",
            "(select date from",
            "(select date(datetime) as date , avg(pmptp) as pmptp from pm10" ,
            "group by date having pmptp between 50 and 79.99) as dates",
            ")",
            "and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure,
            "group by index_number) as meanprofiles;"
        )
    }
    getProfileForLowSeasonWithLowDustQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from", 
            "(select floor(pressure /", step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from", 
            "sounding1" , 
            "where sounding1.date not in (select date from ex_dates_sounding)",
            "and year(sounding1.date) between year(", startDate, ") and year(",endDate, ")" ,
            "and month(sounding1.date)", "in (1,2,12)", 
            "and sounding1.date in",
            "(select date from",
            "(select date(datetime) as date , avg(pmptp) as pmptp from pm10" ,
            "group by date having pmptp between 35 and 49.99) as dates",
            ")",
            "and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure,
            "group by index_number) as meanprofiles;"
        )
    }
    
    getProfileForLowSeasonWithHighDustQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from", 
                "(select floor(pressure /", step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
                    "from", 
                        "sounding1" , 
                "where sounding1.date not in (select date from ex_dates_sounding)",
                    "and year(sounding1.date) between year(", startDate, ") and year(",endDate, ")" ,
                    "and month(sounding1.date)", "in (1,2,12)", 
                    "and sounding1.date in",
                        "(select date from",
                                    "(select date(datetime) as date , avg(pmptp) as pmptp from pm10" ,
                                        "group by date having pmptp between 50 and 79.99) as dates",
                        ")",
                    "and time =", time ,
                    "and pressure between" ,minPressure, "and", maxPressure,
                "group by index_number) as meanprofiles;"
            )
    }
    
    getProfileForLowSeasonWithVeryHighDustQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from", 
            "(select floor(pressure /", step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from", 
            "sounding1" , 
            "where sounding1.date not in (select date from ex_dates_sounding)",
            "and year(sounding1.date) between year(", startDate, ") and year(",endDate, ")" ,
            "and month(sounding1.date)", "in (1,2,12)", 
            "and sounding1.date in",
            "(select date from",
            "(select date(datetime) as date , avg(pmptp) as pmptp from pm10" ,
            "group by date having pmptp >= 80) as dates",
            ")",
            "and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure,
            "group by index_number) as meanprofiles;"
        )
    }
    
    getProfileForHighSeasonQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from (select floor(pressure /",
            step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from sounding1",
            "where date not in (select date from ex_dates_sounding) and year(date) between year(", startDate, ") and year(",endDate, ") and month(date) between 5 and 8 and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure ,
            "group by index_number) as meanProfiles;")
    }
    
    getProfileForIntermediary1SeasonQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from (select floor(pressure /",
            step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from sounding1",
            "where date not in (select date from ex_dates_sounding) and year(date) between year(", startDate, ") and year(",endDate, ") and month(date) in (3,4) and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure ,
            "group by index_number) as meanProfiles;")
    }
    
    getProfileForIntermediary2SeasonQueryString <- function () {
        paste(
            "select index_number * ", step, "as pressure , temp, mixr, relhumidity, windspeed from (select floor(pressure /",
            step ,") as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed",
            "from sounding1",
            "where date not in (select date from ex_dates_sounding) and year(date) between year(", startDate, ") and year(",endDate, ") and month(date) in (9,10,11) and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure ,
            "group by index_number) as meanProfiles;")
    }
    
    getProfileForAMonthQueryString <- function () {
      paste(
           "select month, index_number * ", step, "as pressure , temp, mixr_avg from (select month(date) as month, floor(pressure /",
                step ,") as index_number, avg(temp) as temp, avg(mixr) mixr_avg",
                "from sounding1",
                    "where year(date) between year(", startDate, ") and year(",endDate, ") and time =", time ,
                        "and pressure between" ,minPressure, "and", maxPressure ,
                        "group by month(date),index_number) as meanProfiles;")
    }
    
    getProfileForADayQueryString <- function (date = '2012-06-02') {
        paste(
            "select month, index_number * ", step, "as pressure , temp, mixr_avg from (select month(date) as month, floor(pressure /",
            step ,") as index_number, avg(temp) as temp, avg(mixr) mixr_avg",
            "from sounding1",
            "where date=", startDate, "and time =", time ,
            "and pressure between" ,minPressure, "and", maxPressure ,
            "group by index_number) as meanProfiles;")
    }
    
    getDataProfileForAMonth <- function () {
        dbGetQuery(con, getProfileForLowSeasonWithDustQueryString()) 
    }
    
    library(RMySQL)
    # Open connection to database
    con <- dbConnect(MySQL(),user = 'dbmeteodb', password ='dbmeteodb', host ='localhost', dbname ='dbmeteodb')
    summary(con)
    # dbGetInfo(con)
    # dbListTables(con)
    # dbListFields(con, 'sounding1')
    # dbDataType(RMySQL::MySQL(), 1.5)
    # dbDataType(RMySQL::MySQL(), 1:5)
    # dbReadTable(con, "sounding1")
    
    df.meanProfiles1 = dbGetQuery(con, getProfileForLowSeasonWithLowDustQueryString())
    df.meanProfiles2 = dbGetQuery(con, getProfileForLowSeasonWithHighDustQueryString())
    df.meanProfiles3 = dbGetQuery(con, getProfileForLowSeasonWithVeryHighDustQueryString())
    
    browser()
    
    View(df.meanProfiles)
    
    library(ggplot2)
    
    # ok for different months
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + facet_wrap(~ month) + geom_line() + scale_x_reverse() + coord_flip() + ggtitle(paste0('period:',startDate,'-',endDate))
    
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=mixr)) + geom_line() + scale_x_reverse() + ylab("mixing ratio(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=relhumidity)) + geom_line() + scale_x_reverse() + ylab("relative humidity(%)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=windspeed)) + geom_line() + scale_x_reverse() + ylab("wind speed(knots)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low season (2005-2015)')) 
    
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('High season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=mixr)) + geom_line() + scale_x_reverse() + ylab("mixing ratio(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('High season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=relhumidity)) + geom_line() + scale_x_reverse() + ylab("relative humidity(%)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('High season (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=windspeed)) + geom_line() + scale_x_reverse() + ylab("wind speed(knots)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('High season (2005-2015)')) 
    
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 1 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=mixr)) + geom_line() + scale_x_reverse() + ylab("mixing ratio(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 1 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=relhumidity)) + geom_line() + scale_x_reverse() + ylab("relative humidity(%)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 1 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=windspeed)) + geom_line() + scale_x_reverse() + ylab("wind speed(knots)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 1(2005-2015)')) 
    
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 2 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=mixr)) + geom_line() + scale_x_reverse() + ylab("mixing ratio(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 2 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=relhumidity)) + geom_line() + scale_x_reverse() + ylab("relative humidity(%)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 2 (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=windspeed)) + geom_line() + scale_x_reverse() + ylab("wind speed(knots)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Intermediary season 2(2005-2015)'))
    
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low Season with Dust(35-50) (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=mixr)) + geom_line() + scale_x_reverse() + ylab("mixing ratio(°C)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low Season with Dust(35-50) (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=relhumidity)) + geom_line() + scale_x_reverse() + ylab("relative humidity(%)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low Season with Dust(35-50) (2005-2015)')) 
    #g <- ggplot(df.meanProfiles, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse()  + ylab("wind speed(knots)") + xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low Season with Dust(35-50) (2005-2015)'))
    
    g <- ggplot(df.meanProfiles1, aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() + ylab("temperature(°C)") + 
        xlab("pression (hPa)") + coord_flip() + ggtitle(paste0('Low Season with Dust(35-50) (2005-2015)')) 
    
    g <- g + geom_line(aes (x= pressure, y=temp)) + geom_line() + scale_x_reverse() +  coord_flip()
    
    print( g1 + g2)
    
    
}
