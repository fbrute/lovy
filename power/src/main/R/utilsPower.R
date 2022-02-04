# utilsPower.R for *Power.R files
#
#
#
# () => list_of_string_parameters( station_number, station_name, 
#lower_cut_pressure_, higher_cut_pressure, start_date, end_date)

library(stringr)
getParamsPower <- function (station_name=NULL) {
    station_name_path = "/home/kwabena/Documents/trafin/lovy/src/main/data"
    load(str_glue("{station_name_path]/dfStations.RData"))
    if (!is.null(station_name)) 
        stopifnot(station_name %in% dfStations$station_name)
        (
            list(station_number=78954,
            station_name="pr", 
            lower_cut_pressure=850, 
            higher_cut_pressure=700, 
            start_date=as.Date("1973-01-01"), 
            end_date=as.Date("2020-12-31")
        )
    )
    
    if (is.null(station_name)) {
        station_name = readline("Nom de station?: ")
        stopifnot(station_name %in% c("pr", "barbade", "tenerife", "dakhla", "santodomingo" ) )
    }
   
    station_number <- switch(station_name, "pr"= 78526, "barbade"=78954,
                             "tenerife"=60018, "dakhla"=60096, "santodomingo"=78486 , "saintmarteen"=78866)
    # station_number is not necessary since there is a dataframe per station 
    #station_number = as.numeric(readline("Numéro de station?: "))
    # pr= 78526, Barbade = 78954, Tenerife= 60018, dakhla=60096, santodomingo= 78486
    stopifnot(station_number %in% c(78526, 78954, 60018, 60096, 78486 ) )
    if (mode == "std") {
        higher_cut_pressure = 700 
        lower_cut_pressure =  850 
    }
    else {
        higher_cut_pressure = as.numeric(readline("Pression de coupure haute de la sal?: "))
        lower_cut_pressure = as.numeric(readline("Pression de coupure basse la sal?: "))
        stopifnot(lower_cut_pressure > higher_cut_pressure)
    }
   
    if (dates == "7320") {
        start_date = as.Date("1973-01-01")
        end_date = as.Date("2020-12-31")
    }
    else {
        start_date= as.Date(readline("Date de début?: "))
        end_date= as.Date(readline("Date de fin?: "))
        stopifnot( start_date < end_date )
    }
    #stopifnot( as.Date(start_date) < as.Date(end_date) )
    
    return(list(
        station_number=station_number,
        station_name=station_name,
        lower_cut_pressure=lower_cut_pressure, 
        higher_cut_pressure=higher_cut_pressure, 
        start_date=start_date, 
        end_date=end_date)
    )
}

calcTrapezeArea <- function (b1=4, b2=5, h=2) {
    (b1+b2)/2*h
}

calcDistance <- function (x1=0, y1=0, x2=1,y2=1) {
    sqrt((x2-x1)^2 + (y2-y1)^2)
}