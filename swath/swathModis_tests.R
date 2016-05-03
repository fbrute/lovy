# Test the SwathModis Object
setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("swathModis.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("swathmodisModis.R", {
    describe("swathmodisModis", {
        swathmodis <- new ('SwathModis',date="2012-06-03", north=20,south=10,east=-15,west=-61)
        it("expects to find the 4 limits of the swathmodis", {
            expect_equal(GetNorth(swathmodis), 20 )
            expect_equal(GetSouth(swathmodis), 10 )
            expect_equal(GetWest(swathmodis), -61 )
            expect_equal(GetEast(swathmodis), -15 )
            expect_equal(GetPath(GetConfigData(swathmodis)), 
                         '/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/swathmodis/csv870' )
        })
        
        it("expects to find the julian day given the date in 'YYYY-MM-DD' ", {
            expect_equal(GetJulianDay(swathmodis), 155 )
        }) 
        
        it("expects to find the modis aot not yet computed", {
            expect_equal(GetAot(swathmodis), -1 )
        })
        
        
         
        swathmodis <- SetNorth(swathmodis, 21)
        swathmodis <- SetSouth(swathmodis, 11)
        swathmodis <- SetWest(swathmodis, -61)
        swathmodis <- SetEast(swathmodis, -16)
        
        it("expects to find the 4 limits of the swathmodis updated", {
            expect_equal(GetNorth(swathmodis), 21 )
            expect_equal(GetSouth(swathmodis), 11 )
            expect_equal(GetWest(swathmodis), -61 )
            expect_equal(GetEast(swathmodis), -16 )
        })
        
        it("expects to object to be printed with accuracy", {
            expect_output(print(swathmodis), "The coordinates are West:  -61 , North:  21 , East:  -16 , South:  11 , Aot:  -1" )
        })
        
        swathmodis <- new ('SwathModis',date="2012-06-01", north=16.75,south=15.75,east=-61,west=-62)
        swathmodis <- InitAot(swathmodis)
        
        it("expects to compute the aot", {
            expect_equal(GetAot(swathmodis), 0.513 )
        })
        
        it("expects to object to be printed with accuracy", {
            expect_output(print(swathmodis), "The coordinates are West:  -62 , North:  16.75 , East:  -61 , South:  15.75 , Aot:  0.513" )
        })
    })
})
