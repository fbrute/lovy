library(unsound)
library(magick)



mainUnSounding <- function() {
    startDate <- as.Date("01-01-73", format="%d-%m-%y")
    endDate <- as.Date("31-12-20", format="%d-%m-%y")
    days <- seq(startDate, endDate, "1 day")
    
    getSoundingforADay <- function(day) {
    
        Sys.sleep(3) # be kind to their servers
        
        get_sounding_data(
            region = "naconf",
            date = day,
            from_hr = "12",
            to_hr = "12",
            station_number = "600018"
        )
    }
    
    lapply(days[1:4], FUN=getSoundingforADay)
}
