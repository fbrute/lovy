library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Soundings by day"),
  
  sidebarLayout(
    sidebarPanel(
      dateInput("date",label="Date",
                value= "2012-07-03", format="dd-mm-yyyy", startview="July", language="en"),
      numericInput("lowerpressure",label = "lower pressure value", value = 700),
      numericInput("higherpressure",label = "higher pressure value", value = 900)
      ),
    mainPanel(
      plotOutput("apbmplot")
      ) # mainPanel
    ) # sidebarLayout
  
  ) # fluidPage 
) # shinyUI