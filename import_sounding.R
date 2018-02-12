library(DBI)
library(RMySQL)
library(XML)

# Signal sql strings test, no connection to database established
sqltest <- FALSE

dbg <- T

getFileUrls <- function(years,months,rootPath) {

    outer( paste(rootPath, years,sep = "/"), paste0(months,".html"),
           FUN = function(...) paste(...,sep="/"))
}

mainAllYearsImport <- function(dbg = F) {
    #years <- as.character(c(2005:2012,2015))
    years <- as.character(c(2005:2015))
    months <- c("janvier","fevrier","mars","avril","mai","juin","juillet","aout","septembre",
                "octobre","novembre","decembre")
    #rootPath <- "/data/soundings"   
    rootPath <- "/data/soundings/cape_san_juan"   
    fileUrls <- getFileUrls(years,months,rootPath)
    
    lapply(fileUrls, mainByMonth)
}

mainByFile <- function() {
    fileUrl <- file.choose()
    if (file.exists(fileUrl)) {
        mainByMonth(fileUrl)    
    }
}
mainByYear <- function() {
        if (dbg) browser()
        library(XML)
        if (dbg) browser()
        #fileurls <- c("/data/soundings/2014/janvier.html",
        #              "/data/soundings/2014/fevrier.html",
        #              "/data/soundings/2014/mars.html",
        #              "/data/soundings/2014/avril.html",
        
        fileurls <- Sys.glob("*.html")
        
        if (dbg) browser()
        fileurls <- c("/data/soundings/2014/mai.html",
                      "/data/soundings/2014/juin.html",
                      "/data/soundings/2014/juillet.html",
                      "/data/soundings/2014/aout.html",
                      "/data/soundings/2014/septembre.html",
                      "/data/soundings/2014/octobre.html",
                      "/data/soundings/2014/novembre.html",
                      "/data/soundings/2014/decembre.html"
                      )
        if (dbg) browser()
        
        for (i in 1:length(fileurls)) {
                mainByMonth(fileurls[i])
        }
        
}

mainByMonth <- function(fileurl) {
 
        # Open a file containing data
        
        # con = url("")
        # htmlcode = readLines(con)
        # close(con)
        # 
        # htmlcode
        
        #htmlcode = read
#         library(XML)
#         fileurl <- "~/Documents/Trafin/aptf/2012/soundings//station raizet aout 2012.htm"
        
        #if (dbg) browser()
    
        print(paste("file beeing explored",fileurl, sep=":"))
        
        if (!file.exists(fileurl)) return
        
        doc <- htmlTreeParse(fileurl, useInternal=TRUE)
        
        rootnode <- xmlRoot(doc)
        # h2 contains head of one sounding, including date of course ;-))
        # we can get 2 soundings a day (00Z and 12Z)
        headstrings <- xpathSApply(doc,"//h2", xmlValue)
        datastrings <- xpathSApply(doc,"//pre", xmlValue)
        #<
        # if (!sqltest) {con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
        #         password="dbmeteodb",
        #         dbname="dbmeteodb",
        #         host="localhost")}
        
        if (dbg) browser()
        
        for (i in 1:length(headstrings)){
                # pre contains the data (odd values) or the context (even values) 
                # of the soundings
                headstring <- xpathSApply(doc,"//h2", xmlValue)[i]
                datastring <- xpathSApply(doc,"//pre", xmlValue)[2*i-1]
                contextstring <- xpathSApply(doc,"//pre", xmlValue)[2*i]
                
                # tryCatch(
                #         importData(headstring, datastring), 
                #         finally = dbDisconnect(con)
                #         )
                
                importData(headstring, datastring, contextstring)
        }  
        
        # dbDisconnect(con)
}

# mainByDay <- function() {
# dbg <- 0
# 
# # con = url("")
# # htmlcode = readLines(con)
# # close(con)
# # 
# # htmlcode
# 
# #htmlcode = read
# library(XML)
# fileurl <- "~/Documents/Trafin/aptf/2012/soundings//station raizet aout 2012.htm"
# 
# doc <- htmlTreeParse(fileurl, useInternal=TRUE)
# 
# rootnode <- xmlRoot(doc)
# # h2 contains head of one sounding, including date of course ;-))
# # we can get 2 soundings a day (00Z and 12Z)
# xpathSApply(doc,"//h2", xmlValue)[1]
# 
# # pre contains the data (odd values) or the context (even values) of the soundings
# xpathSApply(doc,"//pre", xmlValue)[1]
# datastring <- xpathSApply(doc,"//pre", xmlValue)[1]
# headstring <- xpathSApply(doc,"//h2", xmlValue)[1]
# dateofsounding <- getDate(headstring)
# timeofsounding <- getTime(headstring)
# data1 <- getData(datastring, dateofsounding, timeofsounding)
# #data1 <- data1[order(data1$pressure, decreasing = TRUE),]
# with(data1, plot(temp,pressure, type= "l", 
#                  xlim= range(temp), 
#                  ylim= rev(range(pressure))))
# 
# with(data1, plot(mixr,pressure,type = "l",
#      xlim= range(mixr), 
#      ylim= rev(range(pressure))))
# View(data1)
# View(data1$pressure)
# data1
# }

# getSoundingData <- function() {
#         
#         # con = url("")
#         # htmlcode = readLines(con)
#         # close(con)
#         # 
#         # htmlcode
#         
#         #htmlcode = read
#         library(XML)
#         fileurl <- "~/Documents/Trafin/aptf/2012/soundings//station raizet aout 2012.htm"
#         
#         doc <- htmlTreeParse(fileurl, useInternal=TRUE)
#         
#         rootnode <- xmlRoot(doc)
#         # h2 contains head of one sounding, including date of course ;-))
#         # we can get 2 soundings a day (00Z and 12Z)
#         xpathSApply(doc,"//h2", xmlValue)[1]
#         
#         # pre contains the data (odd values) or the context (even values) of the soundings
#         xpathSApply(doc,"//pre", xmlValue)[1]
#         datastring <- xpathSApply(doc,"//pre", xmlValue)[1]
#         
#         # get a list of strings representing each an observation
#         strings <- strsplit(datastring, "\n")
#         
#         # data begins at line 5 since we need to skip 4 lines of header with names of columns
#         # each line is an observation at a different pressure
#         x1 <- as.numeric(unlist(strsplit(unlist(strings)[5]," ")))
#         
#         # remove NAs
#         x1 <- x1[!is.na(x1)]
#         
#         x2 <- as.numeric(unlist(strsplit(unlist(strings)[6]," ")))
#         
#         # remove NAs
#         x2 <- x2[!is.na(x2)]
#         
#         matrix1 <- rbind(x1,x2)
#         # get date of sounding
#         stringContainingDate <- xpathSApply(doc,"//h2", xmlValue)[1]
#         posDate <- regexpr("[0-9]{2} [a-yA-Y]* [0-9]{4}$",stringContainingDate)
#         strDate <- substr(stringContainingDate, posDate[1],
#                           posDate[1] + attr(posDate,"match.length") -1)
#         
#         # save local time
#         lct <- Sys.getlocale("LC_TIME")
#         
#         as.Date(strDate,"%d %b %Y")
#         
#         dateofsounding <- getDate(xpathSApply(doc,"//h2", xmlValue)[1])
#         # restore local time
#         Sys.setlocale("LC_TIME",lct)
#         
#         timeofsounding <- getTime(xpathSApply(doc,"//h2", xmlValue)[1])
#         browser()
#         getData(datastring)
#         
#         
# }

getDate  <- function(text) {
        # example in text : 01 Aug 2012
        # get date of sounding, 2012-08-01 (yy-mm-dd by default) 
        posDate <- regexpr("[0-9]{2} [a-yA-Y]* [0-9]{4}$",text)
        strDate <- substr(text, posDate[1],
                          posDate[1] + attr(posDate,"match.length") -1)
        
        # fix NAs with default local system
        Sys.setlocale("LC_TIME", "C")
        as.Date(strDate,"%d %b %Y")
        
}

getTime  <- function(text) {
        # example in text : at 12Z 01 Aug 2012
        # get time of sounding : 12 
        posDate <- regexpr("[0-9]{2}Z",text)
        datestr <- substr(text, posDate[1],
               posDate[1] + attr(posDate,"match.length") -2) # - 2 to get rid of "Z"
        paste(datestr,":00:00", sep="")
}

getStationNumber  <- function(text) {
        # example in text : at 12Z 01 Aug 2012
        # get time of sounding : 12 
        str <- substr(text, 1, 5)
}

headerFactory  <- function(header, nErrValue = -9999999.99) {
    #if (dbg) browser()
    function(text) {
        regValue <- regexpr(paste0(header, "(-?[0-9.]+)"),text)
        posValue <- regValue[1]   + nchar(header)
        #lenCape <- attr(regCape, "match.length") - nchar(header) -1 # -1 because of final /n
        lenValue <- attr(regValue, "match.length") - nchar(header)
        strValue <- substr(text, posValue, posValue + lenValue - 1)
        nValue <-   as.numeric((strValue))
        if (is.na(nValue)) {
            nErrValue
        }
        else {
            if (dbg) browser()
            if(dbg) print(nValue)
            nValue
        }       
    } 

}

getCape <- headerFactory("Convective Available Potential Energy: ", -9999999.99)
getVirtualCape <- headerFactory("CAPE using virtual temperature: ", -9999999.99)

getConv_inhib  <- headerFactory("Convective Inhibition: ", 9999999.99)
getCins <- headerFactory("CINS using virtual temperature: ", 9999999.99)
    
# getConv_inhib  <- function(text) {
#     #if (dbg) browser()
#     header = "Convective Inhibition: "
#     regCins <- regexpr(paste0(header, "(-?[0-9.]+)"),text)
#     posCins <- regCins[1]   + nchar(header)
#     #lenCape <- attr(regCape, "match.length") - nchar(header) -1 # -1 because of final /n
#     lenCins <- attr(regCins, "match.length") - nchar(header)
#     strCins <- substr(text, posCins, posCins + lenCins - 1)
#     nErrCins <- 9999999.99
#     nCins <-   as.numeric((strCins))
#     if (is.na(nCins)) {
#         nErrCins
#     }
#     else {
#         if (dbg) browser()
#         if(dbg) print(nCins)
#         nCins
#     }
# }

# getVirtualCins  <- function(text) {
#     #if (dbg) browser()
#     header = "CINS using virtual temperature: "
#     regCins <- regexpr(paste0(header, "(-?[0-9.]+)"),text)
#     posCins <- regCins[1]   + nchar(header)
#     #lenCape <- attr(regCape, "match.length") - nchar(header) -1 # -1 because of final /n
#     lenCins <- attr(regCins, "match.length") - nchar(header)
#     strCins <- substr(text, posCins, posCins + lenCins - 1)
#     nErrCins <- 9999999.99
#     nCins <-   as.numeric((strCins))
#     if (is.na(nCins)) {
#         nErrCins
#     }
#     else {
#         if (dbg) browser()
#         if(dbg) print(nCins)
#         nCins
#     }
# }
# getVirtualCape  <- function(text) {
#     #if (dbg) browser()
#     header = "CAPE using virtual temperature: "
#     regCape <- regexpr(paste0(header, "([0-9.]+)"),text)
#     posCape <- regCape[1]   + nchar(header)
#     #lenCape <- attr(regCape, "match.length") - nchar(header) -1 # -1 because of final /n
#     lenCape <- attr(regCape, "match.length") - nchar(header)
#     strCape <- substr(text, posCape, posCape + lenCape - 1)
#     nErrCape <- -9999999.99
#     nCape <-   as.numeric((strCape))
#     if (is.na(nCape)) {
#         nErrCape
#     }
#     else {
#         #if (dbg) browser()
#         #print(nCape)
#         nCape
#     }
# }

getStationName  <- function(text) {
        # example in text : at 12Z 01 Aug 2012
        # get time of sounding : 12 
        pos <- regexpr("^.*Observations",text)
        str <- substr(text, 7 , 7 + attr(pos,"match.length") -1 -12 -7)
}

getData <- function(datastrings, dateofsounding, timeofsounding) {
        # get a list of strings representing each an observation
        strings <- strsplit(datastrings, "\n")
        #matrixdata <- matrix(nrow=1, ncol=11)
        # data begins at line 5 since we need to skip 4 lines of header with names of columns
        nallrowsofdata <- length(unlist(strings))
        nrowsofdata <- 0
        datasounding <- numeric()
        for (i in 5:nallrowsofdata){
                #browser()
                # each line is an observation at a different pressure
                rowdata <- as.numeric(unlist(strsplit(unlist(strings)[i]," ")))
                
                # remove NAs
                rowdata <- rowdata[!is.na(rowdata)]
                
                if (length(rowdata) == 11){
                        #matrixdata <- rbind(matrixdata,row
                        # append data of raws in vector data
                        #if (!exists(datasounding, datasounding = numeric()))
                        datasounding <- c(datasounding,rowdata)
                        # send row to database
                        injectRow2Db(rowdata, dateofsounding, timeofsounding)
                        nrowsofdata <- nrowsofdata + 1
                }
                # we save the number of lines retained
        }
        # transform data into a matrix
        datasounding <-matrix(datasounding,nrow = nrowsofdata,ncol = 11, byrow = TRUE)
        datasounding <- data.frame(datasounding, row.names = 1:nrowsofdata )
        colnames(datasounding) <- c("pressure","heigt","temp","dwpt",
                                     "relhumidity","mixr","drct","snkt","thta",
                                     "thte","thtv")
        #matrixdata <- matrixdata[2:dim(matrixdata)[2]-1,]
        #browser()
        datasounding
}

#importData <- function(headstring, datastrings, con) {
importData <- function(headstring, datastrings, contextstring) {
    

        # get a list of strings representing each an observation
        if (dbg) browser()
        strings <- strsplit(datastrings, "\n")
        dateofsounding <- getDate(headstring)
        timeofsounding <- getTime(headstring)
        station_number <- getStationNumber(headstring)
        station_name <- getStationName(headstring)
        cape <- getCape(contextstring)
        cape_virt <- getVirtualCape(contextstring)
        conv_inhib <- getConv_inhib(contextstring)
        cins <- getCins(contextstring)
        #print(paste("importData() :: cape_index", cape_index, sep=":"))
        #matrixdata <- matrix(nrow=1, ncol=11)
        # data begins at line 5 since we need to skip 4 lines of header with names of columns
        nallrowsofdata <- length(unlist(strings))
        datasounding <- numeric()
        for (i in 5:nallrowsofdata){
                #browser()
                # each line is an observation at a different pressure
                rowdata <- as.numeric(unlist(strsplit(unlist(strings)[i]," ")))
                
                # remove NAs
                rowdata <- rowdata[!is.na(rowdata)]
                
                if (length(rowdata) == 11){
                        # send row to database
                        injectRow2Db(rowdata, station_number, station_name,
                                     dateofsounding, timeofsounding, cape, cape_virt, conv_inhib, cins)
                }
        }
}

quote <- function(string){
        paste ("'",string,"'", sep="")
}

sqlpaste <- function(strings){
        for (i in 1:length(strings)) {
                print(strings[i])
        }
}

injectRow2Db <- function(data, station_number, 
                         station_name, dateofsounding, timeofsounding, cape, cape_virt, conv_inhib, cins) {
         library(RMySQL)
         con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                         password="dbmeteodb",
                         dbname="dbmeteodb",
                         host="localhost")
        

        #print(paste("injectRow2Db() :: cape_index", cape_index, sep=":"))
        
        if (dbg) browser()

        sqlstr <- paste("insert into sounding1", 
                        "(station_number, station_name ,date,time,cape,cape_virt,conv_inhib,cins,pressure,",
                        "height,temp, dwpt,",
                        "relhumidity, mixr, drct, snkt, thta, thte, thtv)",
                        "values(",
                        station_number ,",",
                        quote(station_name),",",
                        quote(dateofsounding),",",
                        quote(timeofsounding),",", 
                        cape,",", 
                        cape_virt,",", 
                        conv_inhib,",", 
                        cins,",", 
                        data[1],",",
                        data[2],",",
                        data[3],",",
                        data[4],",",
                        data[5],",",
                        data[6],",",
                        data[7],",",
                        data[8],",",
                        data[9],",",
                        data[10],",",
                        data[11],
                        ")"    
        )
        
        print(sqlstr)
        
        if (dbg) browser()
        tryCatch(
             dbSendQuery(con, sqlstr), 
             finally = dbDisconnect(con)
        )
        
        #dbSendQuery(con, sqlstr)
  
        #dbDisconnect(con)
        #browser()

}