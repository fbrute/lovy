library(RMariaDB)
mainPM <- function() {
    path_to_data = "/home/kwabena/Documents/trafin/lovy/data/airNowPm10"
    setwd(path_to_data)
    
    addDataFrameToMariaDB <- function(file ="") {
        data_frame = read.csv(file=file, stringsAsFactors = FALSE)
        data_frame$Date = MDYToYMD(data_frame$Date)
        dbWriteTable(con, "prpm10", data_frame, append=T)
    }
    
    MDYToYMD <- function(date) {
        year <- substr(date,7,10)
        month <- substr(date,1,2)
        day <- substr(date,4,5)
        paste(year,month,day, sep="-")
    }
    
    files <- Sys.glob("*.csv")
    
    con <- dbConnect(RMariaDB::MariaDB(),  
                     user="dbmeteodb", 
                     password="dbmeteodb",
                     dbname="dbmeteodb",
                     host="localhost")
    
    tryCatch(
        { 
            #create table prpm10
            system("cat ./create_table_pm10.sql | mariadb -udbmeteodb -pdbmeteodb dbmeteodb")
            # add csv file to dbmeteodb
            lapply(files, FUN=addDataFrameToMariaDB)
        },
        finally = { dbDisconnect(con) }
    )
}