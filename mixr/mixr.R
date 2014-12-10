

meanForAMonth <- function (month=1) {
        0        
}

getCon <- function () {
        library(RMySQL)
        
        con = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
                        password="dbmeteodb",
                        dbname="dbmeteodb",
                        host="localhost")
}

getData <- function (con, year, month) {
        sqlstr = paste("select avg(mixr) as meanmixr from sounding1 where year(date)=",
                        year,  "and month(date) =", month ,"group by date")
        
        query <- dbSendQuery(con,  sqlstr)
        
        
        data <- fetch(query, n=-1);
        
        dbClearResult(query)
        
        data

}