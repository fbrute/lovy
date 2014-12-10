.setUp <- function () {
        library(RMySQL)
        library(sqldf)
        
        con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                        password="dbmeteodb",
                        dbname="dbmeteodbtest",
                        host="localhost")
        
        dbDisconnect(con)
        
}

test.nYearDustyDays <- function() {
        checkEquals(nYearDustyDays(2012, 81)
}