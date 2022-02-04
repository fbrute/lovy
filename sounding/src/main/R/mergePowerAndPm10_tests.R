
# Test mergePowerAndPm10.R
library("testthat")
path_to_source <- "/home/kwabena/Documents/trafin/lovy/soundings/src/main/R/"
source(str_glue(path_to_source, "mergePowerAndPm10.R"))
path_to_data_test <- "/home/kwabena/Documents/trafin/lovy/soundings/src/test/"

describe("(mainMergePowerAndPm10)", {
    
    station_name = "pr"
    path_to_data = path_to_data_test
    dfPowerMergedWithPM10 <- mainMergePowerAndPm10(path=path_to_data, station_name=station_name) 
    
    it("expects to return the right value for the CAPE Index", {
        expect_equal( names(dfPowerMergedWithPM10) == c("date", "powerdry",
                                                        "powerhumid",
                                                        "powerwind",
                                                        "stdpowerwind",
                                                        "powerall",
                                                        "cape",
                                                        "cape_virt",
                                                        "meanpm10",
                                                        "stdpm10",
                                                        "nbvaluespm10"))
    })
    
})