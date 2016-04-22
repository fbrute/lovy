# Test the swathObject

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("columnModis.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("columnModis.R", {
    describe("ColumnModis", {
        ColumnModis <- new ('ColumnModis',size=10, north=66)
        it("expects to find the number of columns for the modis swath", {
            expect_equal(GetSize(ColumnModis), 10 )
        })
        
        ColumnModis <- SetSize(ColumnModis, 20)
        it("expects to find the size the simulation updated", {
            expect_equal(GetSize(ColumnModis), 20 )
        })
        
        it("expects to find the north limit of the considered column", {
            expect_equal(GetNorth(GetColumn(ColumnModis,1)), 88 )
        })
        #print(GetColumn(ColumnModis,1))
        #print(GetNorth(GetColumn(ColumnModis,2)))
        it("expects to find the north limit of the considered column", {
                    expect_equal(GetNorth(GetColumn(ColumnModis,1)), 88 )
        })
            
    })
})
 