library("testthat")

path_to_source <- "/home/kwabena/Documents/trafin/lovy/src/main/R/"
source(str_glue(path_to_source, "utils.R"))
path_to_test_data <- "/home/kwabena/Documents/trafin/lovy/src/test/"


describe("utils.R", {
    
    describe("getStations()", {
        dfStations <- getStations() 
        it("expects to get a data frame of stations with name and number", {
            expect_equal(nrow(dfStations), 6)
        })
    })
    
    describe("convertTempFromCelsiusToKelvin()", {
        tempInCelsius <- 25
        tempInKelvin <- convertTempFromCelsiusToKelvin (tempInCelsius)
        it("expects to return the temperature in Kelvins from degrees", {
            expect_equal( tempInKelvin, tempInCelsius + 273.15)
        })
        
    })
    
    describe("convertTempFromKelvinToCelsius",{
        tempInKelvin = 298
        tempInCelsius = convertTempFromKelvinToCelsius(tempInKelvin) 
        it("expect a temperature in Kelvin to be converted to Celsius",{
            expect_equal(tempInCelsius, 298 - 273.15)
        })
    })
    
    describe("countMissingValues()", {
        vector_without_nas = c(1,2,3)
        vector_with_nas = c(1,2,3,NA,NA)
        
        it("expects to return the proper number of missing values", {
            expect_equal(countMissingValues(vector_without_nas), 0)
            expect_equal(countMissingValues(vector_with_nas),2)
        })
        
    })
    
    describe("getNormedDfCols", {
         dF <- as.data.frame(
            list(
                    date =  c("2012-12-12", "2020-12-20", "1973-01-01") ,
                    value1 =  c(13,27,37),
                    value2 =  c(23,77,87),
                    value3 =  c(33,47,67),
                    station_name = rep("pr",3)
                )
        )
        fieldNames = list("value1","value2","value3")
        dF <- getNormedDfCols(col_names = fieldNames, dF=dF, group_col="station_name")
        it("expects to add several normed columns", {
            expect_true( "value1_normed" %in% names(dF))
            expect_true( "value2_normed" %in% names(dF))
            expect_true( "value3_normed" %in% names(dF))
        })
    })
    describe("getNormedDfCol()", {
        dF <- as.data.frame(
            list(
                    date =  c("2012-12-12", "2020-12-20", "1973-01-01") ,
                    value =  c(13,27,37),
                    station_name = rep("pr",3)
                )
        )
        nCols <- ncol(dF)
        meanValue = mean(dF$value) 
        stdValue = sd(dF$value)
        normedValues <- round((dF$value - meanValue)/stdValue,4)
        dFNormed  <- getNormedDfCol(dF = dF , col_name = "value" , group_col = "station_name") 
        it("expects to get a normed column", {
            expect_equal(class(dFNormed), 'data.frame') 
            expect_true('value_normed' %in% names(dFNormed))
            expect_equal(ncol(dFNormed), 1) 
            expect_equal(dFNormed$value_normed, c(-1.0507, 0.1106, 0.9401)  ) 
        })
    })
 
    describe("getData()", {
        dfPm10 <- getData(dataref = "pm10",station_name = "pr")
            
        it("expects to get pm10 values", {
            expect_equal(class(dfPm10), "data.frame" ) 
            expect_true( "pm10mean" %in% names(dfPm10)  ) 
            expect_gt( nrow(dfPm10), 1 ) 
        })
    })
    
    describe("getDateFromFactor()", {
        dfToConvert <- as.data.frame(list(date = ( c("2012-12-12", "2020-12-20", "1973-01-01")) ))
        vDates <- getDateFromFactor(fieldDateName = "date", dF=dfToConvert)
            
        it("expects date as factor are transformed in Date", {
            expect_equal( class(vDates), "Date" ) 
            expect_equal( vDates, as.Date(levels(dfToConvert$date)) ) 
        })
    })
})