# Lovy project
# swath object
# see the swath and maximum of aotmodis values
# Starting : april 2016

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source('swath.R')

source('utils.R')
modeDb = 'PROD'
source('swath.R')
source('configdata.R')

SwathModis <- setClass(
    # Set the name of the class
    Class = "SwathModis",
    
    #Name the data types (slots) that the class will track
    representation(
        date = 'character',
        aot='numeric',
        julianDay = 'numeric',
        configData = 'ConfigData'
        
    ),
    
    #set the defaults values for the slots (optional)
    prototype = list(
        date='2012-06-01',
        julianDay=-1,
        aot=-1,
        configData = new('ConfigData')
    ),
    #Make a function that can test if data is consistent
    validity = function (object) {
        return(TRUE)
    },
    contains = c("Swath")
)

##############  Constructor ##########################
# validity , thru validObject, has to be called explicitly when constructor exists
setMethod(f="initialize",
          signature="SwathModis",
          def=function(.Object,date='2012-06-01', north=20,south=10,east=-15,west=-61)
          {
              library(lubridate)
              date1 = as.Date(date)
              .Object@julianDay = yday(date1)
              .Object@north = north
              .Object@south = south
              .Object@east = east
              .Object@west = west
              #validObject(.Object) # you must explicitly call the 
              # inspector
              return(.Object)
          }
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

setGeneric(name="InitAot",
           def=function(swathModis)
           {
               standardGeneric("InitAot")
           }
)

setMethod(f="InitAot",
          signature="SwathModis",
          definition=function(swathModis)
          {
               
              julian_day= GetJulianDay(swathModis)
              satOrigin = GetSatOrigin(GetConfigData(swathModis))
              data_path = GetPath(GetConfigData(swathModis))
              
              fixnum=6
              
              LONGITUDE = "Longitude"
              LATITUDE  = "Latitude"
              EODAO = "Effective_Optical_Depth_Average_Ocean"
              
              savepath = getwd()
              setwd(data_path)
              #browser()
              tryCatch({
                  latitude  = unlist( get_df_from_csv ( get_csv_filename(data_path, LATITUDE,  julian_day) ) )
              }, warning = function(war) {
                  print(war)
                 return(-2)
              }, error = function(err) {
                  print(err)
                  return(-3)
              }, finally = {
                  if (!exists("latitude")) {
                      return(swathModis) 
                  }
              }
              )
              
              longitude = unlist( get_df_from_csv ( get_csv_filename(data_path, LONGITUDE, julian_day) ) )
              eodao     = unlist( get_df_from_csv ( get_csv_filename(data_path, EODAO,     julian_day) ) )
              
              idxlat  = which(latitude > GetSouth(swathModis) & latitude < GetNorth(swathModis))
              idxlong  = which (longitude > GetWest(swathModis) & longitude < GetEast(swathModis))
              
              idxswath = intersect(idxlat, idxlong)
              
              latitude = latitude[idxswath]
              latitude = round(latitude,4)
              
              longitude = longitude[idxswath]
              longitude = round(longitude,4)
              
              eodao = eodao[idxswath]/1000
              eodao = signif(eodao,fixnum)
              
              setwd(savepath)
              
              swathModis@aot = round(getMean(eodao), 3)
              return(swathModis)
              
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

##############  configData ##########################
setGeneric(name="GetConfigData",
           def=function(swathModis)
           {
               standardGeneric("GetConfigData")
           }
)

setMethod(f="GetConfigData",
          signature="SwathModis",
          definition=function(swathModis)
          {
              return(swathModis@configData)
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

