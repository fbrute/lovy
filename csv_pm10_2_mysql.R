# Import pm10 data from excel files

df.pm10 = read.csv2(file="soundings/PM10_2015.csv")

library(dplyr)
#df.pm10 = mutate(df.pm10, datetime = paste0(levels(datetime),":00"), pmptp = signif(as.numeric(paste(pmptp)), digits = 4))
df.pm10 = mutate(df.pm10, 
                 datetime = paste0( 
                                    levels(datetime),
                                    ":00"
                                    ), 
                 pmptp = as.numeric(paste(pmptp))
                 )

library(RMySQL)
con = dbConnect(drv= MySQL(), user= 'dbmeteodb', password='dbmeteodb', dbname ='dbmeteodb', host='localhost' )

dbWriteTable(con, "pm10", df.pm10, append = TRUE, overwrite = FALSE, row.names = FALSE)

