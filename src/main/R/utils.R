# utils.R
# Support module for tidySounding.R and tidyPower.R
library(stringr)

getStations <- function() {
    path_to_data <- "/home/kwabena/Documents/trafin/lovy/src/main/data"
    load(file = str_glue("{path_to_data}/dfStations.RData"))
    dfStations
}
countMissingValues  <- function(x) {
   sum(is.na(x)) 
}

convertTempFromCelsiusToKelvin <- function(tempInCelsius = NULL) {
    stopifnot(!is.null(tempInCelsius))
    tempInKelvin <- tempInCelsius + 273.15
}

convertTempFromKelvinToCelsius <- function(tempInKelvin = NULL) {
    stopifnot(!is.null(tempInKelvin))
    tempInCelsius <- tempInKelvin - 273.15
}

getNormedDfCols <- function(col_names=NULL, dF=NULL, group_col=NULL) {
    stopifnot(!is.null(dF))
    stopifnot(!is.null(col_names))
    stopifnot(countMissingValues(dF) ==  0)
    stopifnot(!is.null(group_col))
    stopifnot( length(col_names) >= 1)
    stopifnot( length(colnames(dF)) > 1)
    
    list_of_dfs <- lapply(col_names, FUN=getNormedDfCol, dF=dF, group_col=group_col )
    df_results <- reduce(.x = list_of_dfs, .f=cbind) 
}

# returns a df with a normed column
getNormedDfCol <- function(col_name= NULL, dF=NULL, group_col=NULL) {
    stopifnot(!is.null(dF))
    stopifnot(!is.null(col_name))
    #stopifnot(!exists(dF[group_col]))
    stopifnot(countMissingValues(dF[col_name]) ==  0)
    stopifnot(!is.null(group_col))
    
    dfMeansAndStd <- dF %>% group_by(!!as.name(group_col)) %>% 
        summarise(mean =     mean(!!as.name(col_name)), 
                  std =      sd(!!as.name(col_name)), 
        )
    normed_name <- str_glue("{col_name}_normed")
    dF <- dF %>% 
        mutate( "{normed_name}" := round( (dF[[col_name]]-dfMeansAndStd$mean)/dfMeansAndStd$std,4)) %>%
        select( !!as.name(normed_name) )
    
}

# return a "date" column unfactored
getDateFromFactor <- function(fieldDateName ="date", dF = NULL) {
    stopifnot( exists(x=fieldDateName , where=dF) )
    dfDateCol <-   get(x=fieldDateName, pos=dF ) 
    if ( class(dfDateCol) == 'factor') dfDateCol <- as.Date(levels(dfDateCol))
    dfDateCol
}

getData <- function(dataref=NULL, station_name=NULL) {
    getPathToData <- function() {
        str_glue("/home/kwabena/Documents/trafin/lovy/{dataref}/src/main/data/{station_name}")
    }
    
    getBaseName <- function() {
        str_glue("{str_to_title(station_name)}{str_to_title(dataref)}")
    }
    
    getDfFileName <- function() {
        str_glue("{getBaseName()}.RData")
    }
    
    getDfName <- function() {
       str_glue("df{getBaseName()}") 
    }
    
    getDf <- function() {
        load( file_name)
        df_name <- getDfName()
        stopifnot(exists(df_name)) 
        dF <- get(df_name)
        if (dataref == "pm10") {
            dF <- tidyPm10(dF)
        }
        dF
    }
    


    tidyPm10 <- function(dF) {
        # Tidy column name
        if(ncol(dF) == 4){
            if (names(dF) != c("date", "pm10mean", "pm10std", "pm10nbvalues")) {
                names(dF) <-  c("date", "pm10mean", "pm10std", "pm10nbvalues") 
            }
            
            if(class(dF$date) == "factor") {
                dF$date <- getDateFromFactor("date",dF)
            }
        }
        dF
    }
    
    stopifnot(!is.null(station_name))
    stopifnot(!is.null(dataref))
    path_to_data <- getPathToData()
    file_name <- str_glue("{path_to_data}/{getDfFileName()}")
    stopifnot( file.exists(file_name))
    getDf()
}