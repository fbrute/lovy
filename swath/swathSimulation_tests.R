# Test the swathObject

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("swathSimulation.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("swathSimulation.R", {
    describe("SwathSimulation", {
        swathSimul <- new ('SwathSimulation',size=10,north=20,south=10,east=-15,west=-61)
        it("expects to find the 4 limits of the swath", {
            expect_equal(GetSize(swathSimul), 10 )
            expect_equal(GetNorth(swathSimul), 20 )
            expect_equal(GetSouth(swathSimul), 10 )
            expect_equal(GetWest(swathSimul), -61 )
            expect_equal(GetEast(swathSimul), -15 )
        })
        
        swathSimul <- SetSize(swathSimul, 20)
        swathSimul <- SetNorth(swathSimul, 25)
        swathSimul <- SetSouth(swathSimul, 15)
        swathSimul <- SetWest(swathSimul, -60)
        swathSimul <- SetEast(swathSimul, -17)
        
        it("expects to find the size and 4 limits of the swath updated", {
            expect_equal(GetSize(swathSimul), 20 )
            expect_equal(GetNorth(swathSimul), 25 )
            expect_equal(GetSouth(swathSimul), 15 )
            expect_equal(GetWest(swathSimul), -60 )
            expect_equal(GetEast(swathSimul), -17 )
        })
            
    })
})
 