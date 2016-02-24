library(DBI)
library(RMySQL)

# Signal Debug mode
dbg <- F

# Signal sql strings test, no connection to database established
sqltest <- FALSE

mainByYear <- function() {
        library(XML)
#         fileurls <- c("~/Documents/Trafin/aptf/2012/soundings//station raizet janvier 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet fevrier 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet mars 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet avril 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet mai 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet juin 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet juillet 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet septembre 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet octobre 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet novembre 2012.htm",
#                       "~/Documents/Trafin/aptf/2012/soundings//station raizet decembre 2012.htm")
        
        fileurls <- c(#"~/Documents/Trafin/lovy/soundings/jan 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/mar 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/mai 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/juillet 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/aout 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/oct 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/dec 2008.htm",
                      #"~/Documents/Trafin/lovy/soundings/jan 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/mars 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/mai 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/juillet 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/aout 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/oct 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/decembre 2009.htm",
                      #"~/Documents/Trafin/lovy/soundings/jan 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/mars 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/mai 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/juillet 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/aout 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/oct 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/Decembre 2010.htm",
                      #"~/Documents/Trafin/lovy/soundings/Jan 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/mars 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/mai 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/juillet 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/aout 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/oct 2011.htm",
                      #"~/Documents/Trafin/lovy/soundings/dec 2011.htm"
                      )
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
        if (!file.exists(fileurl)) return
        
        doc <- htmlTreeParse(fileurl, useInternal=TRUE)
        
        rootnode <- xmlRoot(doc)
        # h2 contains head of one sounding, including date of course ;-))
        # we can get 2 soundings a day (00Z and 12Z)
        headstrings <- xpathSApply(doc,"//h2", xmlValue)
        datastrings <- xpathSApply(doc,"//pre", xmlValue)
        #<
        if (!sqltest) {con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                password="dbmeteodb",
                dbname="dbmeteodb",
                host="localhost")}
        
        if (dbg) browser()
        
        for (i in 1:length(headstrings)){
                # pre contains the data (odd values) or the context (even values) 
                # of the soundings
                headstring <- xpathSApply(doc,"//h2", xmlValue)[i]
                datastring <- xpathSApply(doc,"//pre", xmlValue)[2*i-1]
                
                tryCatch(
                        importData(headstring, datastring, con), 
                        finally = dbDisconnect(con)
                        )
        }  
        
        dbDisconnect(con)
}

mainByDay <- function() {
dbg <- 0

# con = url("")
# htmlcode = readLines(con)
# close(con)
# 
# htmlcode

#htmlcode = read
library(XML)
fileurl <- "~/Documents/Trafin/aptf/2012/soundings//station raizet aout 2012.htm"

doc <- htmlTreeParse(fileurl, useInternal=TRUE)

rootnode <- xmlRoot(doc)
# h2 contains head of one sounding, including date of course ;-))
# we can get 2 soundings a day (00Z and 12Z)
xpathSApply(doc,"//h2", xmlValue)[1]

# pre contains the data (odd values) or the context (even values) of the soundings
xpathSApply(doc,"//pre", xmlValue)[1]
datastring <- xpathSApply(doc,"//pre", xmlValue)[1]
headstring <- xpathSApply(doc,"//h2", xmlValue)[1]
dateofsounding <- getDate(headstring)
timeofsounding <- getTime(headstring)
data1 <- getData(datastring, dateofsounding, timeofsounding)
#data1 <- data1[order(data1$pressure, decreasing = TRUE),]
with(data1, plot(temp,pressure, type= "l", 
                 xlim= range(temp), 
                 ylim= rev(range(pressure))))

with(data1, plot(mixr,pressure,type = "l",
     xlim= range(mixr), 
     ylim= rev(range(pressure))))
View(data1)
View(data1$pressure)
data1
}

getSoundingData <- function() {
        
        # con = url("")
        # htmlcode = readLines(con)
        # close(con)
        # 
        # htmlcode
        
        #htmlcode = read
        library(XML)
        fileurl <- "~/Documents/Trafin/aptf/2012/soundings//station raizet aout 2012.htm"
        
        doc <- htmlTreeParse(fileurl, useInternal=TRUE)
        
        rootnode <- xmlRoot(doc)
        # h2 contains head of one sounding, including date of course ;-))
        # we can get 2 soundings a day (00Z and 12Z)
        xpathSApply(doc,"//h2", xmlValue)[1]
        
        # pre contains the data (odd values) or the context (even values) of the soundings
        xpathSApply(doc,"//pre", xmlValue)[1]
        datastring <- xpathSApply(doc,"//pre", xmlValue)[1]
        
        # get a list of strings representing each an observation
        strings <- strsplit(datastring, "\n")
        
        # data begins at line 5 since we need to skip 4 lines of header with names of columns
        # each line is an observation at a different pressure
        x1 <- as.numeric(unlist(strsplit(unlist(strings)[5]," ")))
        
        # remove NAs
        x1 <- x1[!is.na(x1)]
        
        x2 <- as.numeric(unlist(strsplit(unlist(strings)[6]," ")))
        
        # remove NAs
        x2 <- x2[!is.na(x2)]
        
        matrix1 <- rbind(x1,x2)
        # get date of sounding
        stringContainingDate <- xpathSApply(doc,"//h2", xmlValue)[1]
        posDate <- regexpr("[0-9]{2} [a-yA-Y]* [0-9]{4}$",stringContainingDate)
        strDate <- substr(stringContainingDate, posDate[1],
                          posDate[1] + attr(posDate,"match.length") -1)
        
        # save local time
        lct <- Sys.getlocale("LC_TIME")
        
        as.Date(strDate,"%d %b %Y")
        
        dateofsounding <- getDate(xpathSApply(doc,"//h2", xmlValue)[1])
        # restore local time
        Sys.setlocale("LC_TIME",lct)
        
        timeofsounding <- getTime(xpathSApply(doc,"//h2", xmlValue)[1])
        browser()
        getData(datastring)
        
        
}

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
        datasounding <-matrix(datasounding,nrow = nrowsofdata,ncol = 11, , byrow = TRUE)
        datasounding <- data.frame(datasounding, row.names = 1:nrowsofdata )
        colnames(datasounding) <- c("pressure","heigt","temp","dwpt",
                                     "relhumidity","mixr","drct","snkt","thta",
                                     "thte","thtv")
        #matrixdata <- matrixdata[2:dim(matrixdata)[2]-1,]
        #browser()
        datasounding
}

importData <- function(headstring, datastrings, con) {
        # get a list of strings representing each an observation
        strings <- strsplit(datastrings, "\n")
        dateofsounding <- getDate(headstring)
        timeofsounding <- getTime(headstring)
        station_number <- getStationNumber(headstring)
        station_name <- getStationName(headstring)
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
                                     dateofsounding, timeofsounding, con)
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
                         station_name, dateofsounding, timeofsounding, con) {
#         library(RMySQL)
#         con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
#                         password="dbmeteodb",
#                         dbname="dbmeteodb",
#                         host="localhost")
        


        sqlstr <- paste("insert into sounding1", 
                        "(station_number, station_name ,date,time, pressure,",
                        "height,temp, dwpt,",
                        "relhumidity, mixr, drct, snkt, thta, thte, thtv)",
                        "values(",
                        station_number ,",",
                        quote(station_name),",",
                        quote(dateofsounding),",",
                        quote(timeofsounding),",", 
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
        #browser()
#         tryCatch(dbSendQuery(con,
#                     sqlstr), finally = dbDisconnect(con))
        dbSendQuery(con, sqlstr)
  
        #dbDisconnect(con)
        #browser()

}
