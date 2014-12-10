library(RMySQL)

library(shiny)

dbg <- 0

shinyServer(function (input, output) {
  
  output$apbmplot <- renderPlot({

    soundingbydaydata <- getData("sounding")
    
    par(mfrow = c(1,2))
    with(soundingbydaydata, plot(temp,pressure, type= "l", 
                     xlim= range(temp), 
                     ylim= rev(range(pressure))), main = "Pressure and Temperature")
    
    with(soundingbydaydata, plot(mixr,pressure,type = "l",
                     xlim= range(mixr), 
                     ylim= rev(range(pressure))), main = "Pressure and Mixed Ratio")
  })
  
prepData <- function () {
  
}

getData <- function(datatype=""){
  # Init string to know if it is valid at the end of the function
  QueryString <- ""
  
  if (datatype == "sounding")
    QueryString <- paste( 
    "select date, time , pressure, mixr, temp", 
      "from sounding1",
      "where date =", "'" , input$date ,"'" ,
        "and time = '12:00:00'",
        "and pressure between", input$lowerpressure ,"and", input$higherpressure,
     "order by pressure desc;"
    )
 
  
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
  if (dbg) browser()
  queryResultsData <- dbSendQuery(con, queryString)
    
    
  #get the data
  data <- fetch(queryResultsData, n=-1)
  # freeing resources
  dbClearResult(queryResultsData) 
  dbDisconnect(con)
  View(data)  
  data
}

})
# TODO
# décalage d'une heure entre pm10_16 et pm10_24, ok entre 1 et 23 pour l'instant
# comment traiter les jours où il y a peu de données aot ? moins de 3 ?
