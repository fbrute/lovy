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
        configdata <- new ('ConfigData', satOrigin = 'TERRA', aotLength)
        it("expects to find the 4 limits of the configdata", {
            expect_equal(GetPath(configdata),  )
            expect_equal(GetSouth(configdata), 10 )
            expect_equal(GetWest(configdata), -61 )
            expect_equal(GetEast(configdata), -15 )
        })
        
        it("expects to find the 4 limits of the configdata", {
            expect_equal(GetJulianDay(configdata), 155 )
        }) 
        
        it("expects to find the modis aot not yet computed", {
            expect_equal(GetAot(configdata), -1 )
        })
        
        configdata <- SetNorth(configdata, 21)
        configdata <- SetSouth(configdata, 11)
        configdata <- SetWest(configdata, -61)
        configdata <- SetEast(configdata, -15)
        
        it("expects to find the 4 limits of the configdata updated", {
            expect_equal(GetNorth(configdata), 21 )
            expect_equal(GetSouth(configdata), 11 )
            expect_equal(GetWest(configdata), -61 )
            expect_equal(GetEast(configdata), -15 )
        })
        
        
        
        it("expects to object to be printed with accuracy", {
            expect_output(print(configdata), "The coordinates are West:  -61 , North:  21 , East:  -15 , South:  11 , Aot:  -1" )
        })
    })
})
