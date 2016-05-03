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
        aotLength = 'numeric',
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
              path= "/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/swathmodis/csv"
              missingDates = c( 54, 132, 151, 158, 183, 222, 279, 286, 314)
          }
          
          if (satOrigin == 'AQUA') {
              path= "/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MYD04_L2/swathmodis/csv"
              missing_dates = c( 310, 316, 317) 
          }
              
          path = paste(path,aotLength,sep='')
          .Object@satOrigin = satOrigin
          .Object@path = path
          .Object@missingDates = missingDates
          .Object@aotLength = aotLength
          .Object@algo = algo
          return(.Object)
          }
)
##############  SatOrigin ##########################
setGeneric(name="GetSatOrigin",
           def=function(ConfigData)
           {
               standardGeneric("GetSatOrigin")
           }
)

setMethod(f="GetSatOrigin",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              return(ConfigData@satOrigin)
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


##############  AotLength ##########################
setGeneric(name="GetAotLength",
           def=function(ConfigData)
           {
               standardGeneric("GetAotLength")
           }
)

setMethod(f="GetAotLength",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              return(ConfigData@aotLength)
          }
)

setGeneric(name="SetAotLength",
           def=function(ConfigData)
           {
               standardGeneric("SetAotLength")
           }
)

setMethod(f="SetAotLength",
          signature="ConfigData",
          definition=function(ConfigData)
          {
              
              return(ConfigData@aotLength)
          }
)
##############  Show ##########################

setMethod(f="show",
          signature="ConfigData",
          def=function(object)
          {
              cat("aot length:",object@aotLength,
                  ", path:" , object@path)
          }
)

