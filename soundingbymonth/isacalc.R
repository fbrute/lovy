library(RMySQL)
dbg <- F

mainIsalcalcAllYears <- function () {
    years <- as.character(c(2013,2014))
    times = c("12:00:00")
    lowerpressure = 700
    higherpressure = 850

    params <- outer(years, times, lowerpressure, higherpressure, FUN = function(...) paste(..., sep=","))
    
    lapply(params, mainIsalcalcOneYear)

}

mainIsalcalcOneYear <- function (params) {
    
    soundingdata <- getSoundingData(params)
    
    params <- unlist(strsplit(params[1],","))
    year <- params[1]
    time <- params[2]
    
    if(dbg) browser()
    
    z <- soundingdata[,4]
    thtv <- soundingdata[,7]
    
    datelevels <- factor(soundingdata$date)
    #data2 <- subset(soundingdata,select = c(date,surfadiab))
    data2 <- subset(soundingdata,select = c(date, height, thtv, cape))
    dfs <- split(data2, datelevels)
    #lapply(dfs, function(elt) sum(elt$surfadiab))
    #lapply(dfs, function(elt) calcisal(elt$height,elt$thtv))
    #unlist(lapply(dfs, function(elt) sum(elt$surfadiab)))
    
    if (dbg) browser()
    
    powers <- round(as.numeric(unlist(lapply(dfs, function(elt) calcisal(calcisalelt(elt$height, elt$thtv))))),2)
    capes <- as.numeric(unlist(lapply(dfs, function(elt) elt$cape[1])))
    
    
    df.powers <- data.frame(levels(datelevels), powers, capes)
    #df.powers2 <- data.frame(levels(datelevels), powers) 
    
    colnames(df.powers) <- c("date", "isal","cape")
    #colnames(df.powers2) <- c("date", "power")
    
    #save(soundingdata, file="soundingdata.RData")
    #save(df.powers, file="df.powers.RData")
    write.csv(df.powers,  file=paste0("isal",year,"_",substr(time,1,2),"Z", ".csv"), row.names = F)
    write.xlsx(df.powers, file=paste0("isal",year,"_",substr(time,1,2),"Z", ".xlsx"), colNames = TRUE) 
}


calcisalelt <- function (z,thtv) {
    thtv1 = rep(thtv[1], length(thtv) -1)
    thtvn = head(thtv, length(thtv) -1)
    thtvnplus1 = tail(thtv, length(thtv) -1)
    zn = head(z, length(z) -1)
    znplus1 = tail(z, length(z) -1)
    
   (znplus1 - zn)/2 * ( (thtv1 - thtvnplus1) / thtvnplus1 +  (thtv1 - thtvn) / thtvn)
}

calcisal <- function (isalvector) {
    sum(isalvector) * 9.81
}

getSoundingData <- function(params){
    params <- unlist(strsplit(params[1],","))
    year <- params[1]
    time <- params[2]
    lowerpressure <- params[3]
    higherpressure <- params[4]
    
    firstDate <- paste(year,"01","01",sep='-')
    lastDate <-  paste(year,"12","31",sep='-')
    
    # Init string to know if it is valid at the end of the function
    QueryString <- ""
    if (dbg) browser()
    
    print(paste0("datestart=", firstDate))
    print(paste0("datestop=", lastDate))
    QueryString <- paste( 
        "select date, time , pressure, height, mixr, temp, thtv, cape", 
        "from sounding1",
        "where date between", wrap_quote(firstDate),
        "and" , wrap_quote(lastDate),
        "and time =", wrap_quote(time),
        "and pressure between", lowerpressure ,"and", higherpressure,
        "order by date, pressure desc;"
    )
    
    if (dbg) browser()
    if (QueryString != "")
        return(getMysqlData(QueryString))
    
}

getMysqlData <- function(queryString=""){
    #   View(queryString)
    con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                    password="dbmeteodb",
                    dbname="dbmeteodb",
                    host="localhost")
    
    # send the query
    #                 if (dbg) browser()
    queryResultsData <- dbSendQuery(con, queryString)
    
    
    #get the data
    data <- fetch(queryResultsData, n=-1)
    
    if (dbg) browser()
    
    # freeing resources
    dbClearResult(queryResultsData) 
    dbDisconnect(con)
    #View(data)  
    data
}

wrap_quote <- function(string){
    paste0("'",string,"'")
}