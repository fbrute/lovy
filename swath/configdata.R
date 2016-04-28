# Lovy project
# config object, path and missing dates for data
# see the swath and maximum of aotmodis values
# Starting : april 2016

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

modeDb = 'PROD'
source('utils.R')

ConfigData <- setClass(
    # Set the name of the class
    Class = "ConfigData",
    
    #Name the data types (slots) that the class will track
    representation(
        satOrigin = 'character',
        algo = 'character',
        aotLength = 'character',
        path = 'character',
        missingDates = 'numeric'
    )
)

##############  Constructor ##########################
# validity , thru validObject, has to be called explicitly when constructor exists
setMethod(f="initialize",
          signature="ConfigData",
          def=function(.Object, satOrigin = 'TERRA', algo ='O',  aotLength=870)
          {
          if (satOrigin == 'TERRA') {
              path= "/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/csv"
              missingDates = c( 54, 132, 151, 158, 183, 222, 279, 286, 314)
          }
          
          if (satOrigin == 'AQUA') {
              path= "/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MYD04_L2/csv"
              missing_dates = c( 310, 316, 317) 
          }
          path = paste(path,aotLength,sep='')
          .Object@path = path
          .Object@missingDates = missingDates
          .Object@algo = algo
          return(.Object)
          }
)


##############  Aot Retrieval ##########################
setGeneric(name="GetPath",
           def=function(ConfigData)
           {
               standardGeneric("GetPath")
           }
)

setMethod(f="GetPath",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              return(ConfigData@path)
          }
)

setGeneric(name="SetAot",
           def=function(ConfigData)
           {
               standardGeneric("SetAot")
           }
)

setMethod(f="SetAot",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              
              return(ConfigData@aot)
          }
)
##############  Julian Day Retrieval ##########################
setGeneric(name="GetJulianDay",
           def=function(ConfigData)
           {
               standardGeneric("GetJulianDay")
           }
)

setMethod(f="GetJulianDay",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              return(ConfigData@julianDay)
          }
)
##############  Show ##########################

setMethod(f="show",
          signature="Swath",
          def=function(object)
          {
              cat("The coordinates are West: ",object@west,", North: ",object@north,", East: ", object@east,
                  ", South: ", object@south, ", Aot: ", object@aot ,"\n")
          }
)

