library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Soundings by month"),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("daterange",label="Date Range",
                start= "2012-07-01", end = "2012-07-03", format="dd-mm-yyyy", 
                startview="July", language="en"),
      numericInput("lowerpressure",label = "lower pressure value", value = 700),
      numericInput("higherpressure",label = "higher pressure value", value = 850),
      selectInput("time", "Time:",
                  c("12Z" = "12:00:00",
                    "00Z" = "00:00:00")),
      checkboxInput("display", "Display plot?", FALSE)
      ),
    mainPanel(
      plotOutput("apbmplot")
      ) # mainPanel
    ) # sidebarLayout
  
  ) # fluidPage 
) # shinyUI