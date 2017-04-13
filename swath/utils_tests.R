# Test the SwathModis Object
setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/swath")

source("utils.R")

# Choose the right database (before sourcing utils.R)
modeDb = "TEST"

source("utils.R")
library("testthat")

suppressWarnings(warning("testit"))

describe("utils.R", {
    describe("mergeVectorsWithoutDuplicates()", {
        v1 = seq(1,20)
        v2 = seq(5,25)
        
        it("expects to remove duplicates from vector v2 and return the concatenation of vectors v1 and v2", {
            expect_equal( 
                            mergeVectorsWithoutDuplicates(v1,v2),
                            c(
                               seq(1,20),
                               rep(NA,16),
                               seq(21,25)
                             )
            )
            
        })
        
        v1 = seq(1,20)
        v2 = seq(5,15)
        
        it("expects to remove duplicates from vector v2 and return the concatenation of vectors v1 and v2", {
            expect_equal( 
                mergeVectorsWithoutDuplicates(v1,v2),
                c(
                    seq(1,20),
                    rep(NA,11)
                )
            )
            
        })
        
        v1 = seq(15,30)
        v2 = seq(10,25)
        
        it("expects to remove duplicates from vector v2 and return the concatenation of vectors v1 and v2", {
            expect_equal( 
                mergeVectorsWithoutDuplicates(v1,v2),
                c(
                    seq(15,30),
                    seq(10,14),
                    rep(NA,11)
                )
            )
            
        })
        set.seed(777)
        v1 = rnorm(10, 16,3)
        n16OfV1 = length(v1[v1 < 17 & v1 > 16])
        
        v2 = rnorm(10,14,3)
        n16OfV2 = length(v2[v2 < 17 & v2 > 16])
        
        it("expects to remove duplicates from vector v2 and return the concatenation of vectors v1 and v2", {
            v1AndV2Merged =  mergeVectorsWithoutDuplicates(v1,v2)
            expect_equal(  length(na.omit(v1AndV2Merged[v1AndV2Merged > 16 & v1AndV2Merged < 17])) , n16OfV1 )
        })
    })
})