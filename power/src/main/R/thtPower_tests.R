# Test thtPower.R 
#

library("testthat")
library(stringr)
path_to_source <- "/home/kwabena/Documents/trafin/lovy/power/src/main/R/"
source(str_glue(path_to_source, "thtPower.R"))
path_to_data <- "/home/kwabena/Documents/trafin/lovy/power/src/main/Data" 

describe("thtPower.R", {
    
    describe("getThtBased(colName)", {
        dfSounding <- getData(dataref="sounding", station_name="pr") %>% filter(dateofsounding == as.Date("2015-12-01"))
        stopifnot(nrow(dfSounding) == 162)
        
        paramsList = paramsList(station_name="pr")
        dfThta <- getThtBased(paramsList, dfSounding, "thta")
        
        it("expects to return a dataframe with the correct data", {
            expect_true( 'powerThta' %in% colnames(dfThta) )
        })
        
    })
})