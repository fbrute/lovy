# Lovy project
# colModis Simulation
# see the colModis and maximum of aotmodis values
# Starting : april 2016

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")
source('swath.R')

modeDb = 'PROD'
source('utils.R')

ColumnModis <- setClass(
        # Set the name of the class
        Class = "ColumnModis",
        
        #Name the data types (slots) that the class will track
        representation  (
                size='numeric', # the number of columns,
                columns='list'
        ),
        
        #set the defaults values for the slots (optional)
        prototype = list(
                size = 10,
                columns= list(new('Swath', north=88), new('Swath', north=77))
        ),
        #Make a function that can test if data is consistent
        validity = function (object) {
                if (object@size < 1) {
                       return("Error: The size cannot be lesser than 1")
                }
        
                
                return(TRUE); 
        },
        contains = c("Swath")
)
setGeneric(name="GetSize",
           def=function(colModis)
           {
                   standardGeneric("GetSize")
           }
)

setMethod(f="GetSize",
          signature="ColumnModis",
          definition=function(colModis)
          {
                  return(colModis@size)
          }
)


setGeneric(name="SetSize",
           def=function(colModis,size)
           {
                   standardGeneric("SetSize")
           }
)

setMethod(f="SetSize",
          signature="ColumnModis",
          definition=function(colModis, size)
          {
                  colModis@size = size
                  return(colModis)
                  
          }
)
##############  Column ##########################
setGeneric(name="GetColumn",
           def=function(colModis,index)
           {
                   standardGeneric("GetColumn")
           }
)

setMethod(f="GetColumn",
          signature="ColumnModis",
          definition=function(colModis,index)
          {
                  return(colModis@columns[[index]])
          }
)


setGeneric(name="SetColumn",
           def=function(colModis,index,swath)
           {
                   standardGeneric("SetColumn")
           }
)

setMethod(f="SetColumn",
          signature="ColumnModis",
          definition=function(colModis, index, swath)
          {
                  colModis@columns[index] = swath
                  return(colModis)
                  
          }
)