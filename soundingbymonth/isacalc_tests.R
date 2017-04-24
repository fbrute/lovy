# Test the isalcal.R file

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundingbymonth")
dbg = T

library("testthat")
source("isacalc.R")

describe("isacalc.R", {
    describe("calcisalelt()", {
        
        z    = c(1511, 1612, 2647)
        thtv = c(306.7, 307.3, 309.4)
        
        it("expects to return the right value for a vector of 3 given pressures", {
            expect_equal( calcisalelt(z,thtv)[1], -0.0986  , tolerance = 0.01)
            expect_equal( calcisalelt(z,thtv)[2], -5.5264  , tolerance = 0.01)
            
        })
        
        z    = c(1563,  1683,   1856,  3170,  3182)
        thtv = c(302.5, 302.9 , 303.9, 311.0, 310.9)
        
        it("expects to return the right values for 2012, january, first", {
        expect_equal( calcisalelt(z,thtv)[1], -0.0792  , tolerance = 0.01)
        expect_equal( calcisalelt(z,thtv)[2], -0.5127  , tolerance = 0.01)
        expect_equal( calcisalelt(z,thtv)[3], -20.9832  , tolerance = 0.01)
        expect_equal( calcisalelt(z,thtv)[4], -0.3261  , tolerance = 0.01)
        
        })
 
        
    })
    
    describe("calcisal()", {
        
        z    = c(1511, 1612, 2647)
        thtv = c(306.7, 307.3, 309.4)
        
        it("expects to return the right value for a vector of 3 given pressures", {
            calcisalvector = calcisalelt(z,thtv)
            isal = calcisal(calcisalvector)
            if (dbg) {print(calcisalvector)}
            if (dbg) {print(isal)}
            expect_equal( isal, -55.18  , tolerance = 0.01)
            
        })
        
        z    = c(1563,  1683,   1856,  3170,  3182)
        thtv = c(302.5, 302.9 , 303.9, 311.0, 310.9)
        
         it("expects to return the right value for 2012, january, first", {
            calcisalvector = calcisalelt(z,thtv)
            isal = calcisal(calcisalvector)
            if (dbg) {print(calcisalvector)}
            if (dbg) {print(isal)}
            expect_equal( isal, -214.85  , tolerance = 0.01)
        })
        
    })
})