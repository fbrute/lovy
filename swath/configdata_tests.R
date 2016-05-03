# Test the configdata Object
setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("configdata.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("configdata.R", {
    describe("ConfigData", {
        configdata <- new ('ConfigData', satOrigin = 'TERRA', aotLength=870)
        
        it("expects to see the aot length value with a value", {
            expect_equal(GetAotLength(configdata), 870 )
        })
        
        it("expects to have an name of satelitte", {
            expect_equal(GetSatOrigin(configdata), 'TERRA' )
        })  
        
        it("expects to find the path to the hdf data", {
            expect_equal(GetPath(configdata), 
                '/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/csv870' )
        })
        
        it("expects to object to be printed with accuracy", {
            expect_output(print(configdata), "aot length: 870 , path: /Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/csv870" )
        })
    })
})
