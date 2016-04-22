# Test the swathObject
setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("swath.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("Swath.R", {
    describe("Swath", {
        #Swath <- new ('Swath',north=20,south=10,east=-15,west=-61)
        Swath <- new ('Swath')
        it("expects to find the 4 limits of the swath", {
            expect_equal(GetNorth(Swath), 20 )
            expect_equal(GetSouth(Swath), 10 )
            expect_equal(GetWest(Swath), -61 )
            expect_equal(GetEast(Swath), -15 )
        })
        
        Swath <- SetNorth(Swath, 25)
        Swath <- SetSouth(Swath, 15)
        Swath <- SetWest(Swath, -60)
        Swath <- SetEast(Swath, -17)
        
        it("expects to find the 4 limits of the swath updated", {
            expect_equal(GetNorth(Swath), 25 )
            expect_equal(GetSouth(Swath), 15 )
            expect_equal(GetWest(Swath), -60 )
            expect_equal(GetEast(Swath), -17 )
        })
        
        
        
         it("expects to object to be printed with accuracy", {
            expect_output(print(Swath), "The coordinates are West:  -60 , North:  25 , East:  -17 , South:  15 " )
        })
    })
})
