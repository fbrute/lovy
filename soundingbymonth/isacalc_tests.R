# Test the isalcal.R file

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundingbymonth")

library("testthat")
source("isacalc.R")

describe("isacalc.R", {
    describe("calcisalelt()", {
        
        z    = c(1511, 1612, 2647)
        thtv = c(306.7, 307.3, 309.4)
        
        it("expects to return the right value for a vector of 3 given pressures", {
            expect_equal( calcisalelt(z,thtv)[1], -0.0986  , tolerance = 0.0001)
            expect_equal( calcisalelt(z,thtv)[2], -5.5264  , tolerance = 0.0001)
            
        })
        
    })
    
    describe("calcisal()", {
        
        z    = c(1511, 1612, 2647)
        thtv = c(306.7, 307.3, 309.4)
        
        it("expects to return the right value for a vector of 3 given pressures", {
            calcisalvector = calcisalelt(z,thtv)
            isal = calcisal(calcisalvector)
            print(calcisalvector)
            expect_equal( isal, -55.1812  , tolerance = 0.0001)
            
        })
        
    })
})