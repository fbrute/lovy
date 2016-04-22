# Lovy project
# swath object
# see the swath and maximum of aotmodis values
# Starting : april 2016

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source('swath.R')

modeDb = 'PROD'
source('utils.R')

SwathModis <- setClass(
    # Set the name of the class
    Class = "SwathModis",
    
    #Name the data types (slots) that the class will track
    representation(
        date = 'character',
        aot='numeric',
        julianDay = 'numeric'
    ),
    
    #set the defaults values for the slots (optional)
    prototype = list(
        date='2012-06-01',
        julianDay=-1,
        aot=-1
    ),
    #Make a function that can test if data is consistent
    validity = function (object) {
        return TRUE   
    },
    contains = c("Swath")
)



##############  Aot Retrieval ##########################
setGeneric(name="GetAot",
           def=function(swathModis)
           {
               standardGeneric("GetAot")
           }
)

setMethod(f="GetAot",
          signature="SwathModis",
          definition=function(swathModis)
          {
              return(swathModis@aot)
          }
)
##############  Julian Day Retrieval ##########################
setGeneric(name="GetJulianDay",
           def=function(swathModis)
           {
               standardGeneric("GetJulianDay")
           }
)

setMethod(f="GetJulianDay",
          signature="SwathModis",
          definition=function(swathModis)
          {
              return(swathModis@julianDay)
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