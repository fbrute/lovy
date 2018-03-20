library(readxl)
library(hash)
library(RMySQL)
source("~/modtf/rproject/utils.R")

main <- function ()
{
    
     #sheetnames = as.character(c(2006:2016))
     #v_end_of_rows = c(35062, 35143, 35159, 35143, 35062, 35062, 35239, 35142, 35061, 35062, 4775 )
    
     couples_end_of_rows = list(c(2006,35062), c(2007, 35143), c(2008, 35159),c(2009, 35143), c(2010,35062), c(2011, 35062),
                                c(2012,35239), c(2013,35142), c(2014,35061), c(2015,35062), c(2016,4775) )
     
    #h_end_of_rows = hash(c(2006:2016), c(35062, 35143, 35159, 35143, 35062, 35062, 35239, 35142, 35061, 35062, 4775  ))    
   
    dfs = lapply(couples_end_of_rows, (function(x) getWindataFromExcel(x)))
    str(dfs)
    
    # Add wind datas to database
    connexion = getDbConnexion(modeDb = "PROD")
    system("mysql -u dbmeteodb --password=dbmeteodb dbmeteodb -e 'drop table if exists wind14 ; create table wind14 (idx int auto_increment primary key , dateheure datetime not null, dirvent double not null, vitvent double not null);' ")
    lapply(dfs, function(df) dbWriteTable(conn = connexion, name = "wind14", value = df, append = T, row.names = F))
    
}

getWindataFromExcel <- function( lst_Wind ) {
    
    sheet_name = as.character(lst_Wind[1])
    max_row = lst_Wind[2]
    
    setwd("~/lovy/data/pm10")
    number_of_lines_skipped = 21
 
    
    #last_lines_of_data = []
    #xl1 = read.xlsx("pm10_1_4h_2005_2016.xlsx", sheet = 2, startRow = first_line_of_data_index)
    
    xl1 = read_excel("pm10_1_4h_2005_2016.xlsx", sheet=sheet_name , skip= number_of_lines_skipped)
    
    
    xl1 = xl1[,c(15,16,19)]
    
    colnames(xl1) <- c("dateheure", "dirvent", "vitvent")
    
    xl1 = xl1[1:max_row,]
    
    class(xl1) <- c("data.frame")
    
    xl1= na.omit(xl1)
}

# getDbConnexion = function(modeDb='PROD') {
#     
#     library(RMySQL)
#     
#     print(sprintf ("getDbConnexion() : modeDb=%s", modeDb) )
#     
#     if (toupper(modeDb) == 'TEST') {
#         #dbConnexion = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
#         dbConnexion = dbConnect(MySQL(), user="dbmeteodb", 
#                                 password="dbmeteodb",
#                                 dbname="dbmeteodbtest",
#                                 host="localhost")
#     }
#     
#     if (toupper(modeDb) == 'PROD') {
#         #dbConnexion = dbConnect(dbDriver("MySQL"), user="dbmeteodb", 
#         dbConnexion = dbConnect(MySQL(), user="dbmeteodb", 
#                                 password="dbmeteodb",
#                                 dbname="dbmeteodb",
#                                 host="localhost")
#     }
#     
#     dbConnexion 
# }
