# Lovy project
# swath object
# see the swath and maximum of aotmodis values
# Starting : april 2016

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

modeDb = 'PROD'
source('utils.R')

Swath <- setClass(
    # Set the name of the class
    Class = "Swath",
    
    #Name the data types (slots) that the class will track
    representation(
        west='numeric',
        north='numeric',
        east='numeric',
        south='numeric'
    ),
    
    #set the defaults values for the slots (optional)
    prototype = list(
        west = -61,
        north=20,
        south=10,
        east=-15
    ),
    #Make a function that can test if data is consistent
    validity = function (object) {
        if (object@north > 90 || object@north < -90) {
            return("Error: The north boundary is not between [-90°,90°]")
        }
        if (object@south > 90 || object@south < -90) {
            return("Error: The south boundary is not between [-90°,90°]")
        }
        if (object@west < -180 || object@west > 180) {
            return("Error: The west boundary is  not between[-180°,180]")
        }
        if (object@east < -180 || object@east > 180) {
            return("Error: The east boundary is  not between[-180°,180]")
        }
        if(object@north < object@south) {
            return("Error: The north boundary is  lesser than the south bondary")
        }
        if(object@west > object@east) {
            return("Error: The west boundary is  greater than the east bondary")
        }
        return(TRUE); 
    } 
)



##############  North Limit ##########################
setGeneric(name="GetNorth",
           def=function(swath)
           {
               standardGeneric("GetNorth")
           }
)

setMethod(f="GetNorth",
          signature="Swath",
          definition=function(swath)
          {
              return(swath@north)
          }
)


setGeneric(name="SetNorth",
           def=function(swath,north)
           {
               standardGeneric("SetNorth")
           }
)

setMethod(f="SetNorth",
          signature="Swath",
          definition=function(swath, north)
          {
              swath@north = north
              return(swath)
              
          }
)
##############   South Limit ##########################
setGeneric(name="GetSouth",
           def=function(swath)
           {
               standardGeneric("GetSouth")
           }
)

setMethod(f="GetSouth",
          signature="Swath",
          definition=function(swath)
          {
              return(swath@south)
          }
)


setGeneric(name="SetSouth",
           def=function(swath,south)
           {
               standardGeneric("SetSouth")
           }
)

setMethod(f="SetSouth",
          signature="Swath",
          definition=function(swath, south)
          {
              swath@south = south
              return(swath)
              
          }
)
##############   East Limit ##########################
setGeneric(name="GetEast",
           def=function(swath)
           {
               standardGeneric("GetEast")
           }
)

setMethod(f="GetEast",
          signature="Swath",
          definition=function(swath)
          {
              return(swath@east)
          }
)


setGeneric(name="SetEast",
           def=function(swath,east)
           {
               standardGeneric("SetEast")
           }
)

setMethod(f="SetEast",
          signature="Swath",
          definition=function(swath, east)
          {
              swath@east = east
              return(swath)
              
          }
)
##############   West Limit ##########################
setGeneric(name="GetWest",
           def=function(swath)
           {
               standardGeneric("GetWest")
           }
)

setMethod(f="GetWest",
          signature="Swath",
          definition=function(swath)
          {
              return(swath@west)
          }
)


setGeneric(name="SetWest",
           def=function(swath,west)
           {
               standardGeneric("SetWest")
           }
)

setMethod(f="SetWest",
          signature="Swath",
          definition=function(swath, west)
          {
              swath@west = west
              return(swath)
              
          }
)

setMethod(f="show",
          signature="Swath",
          def=function(object)
          {
              cat("The coordinates are West: ",object@west,", North: ",object@north,", East: ", object@east,
                    ", South: ", object@south, "\n")
          }
)