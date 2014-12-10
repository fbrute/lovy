mixr.test <- function () {
        
        library(RUnit)
        #library(testthat)
        
        testsuite.mixr <- defineTestSuite("mixr", 
                                          dirs = file.path(paste(getwd(),
                                                                 "/mixr",sep="")),
                                          testFileRegexp = "^runit.+\\.R", 
                                          testFuncRegexp = "^test.+", 
                                          rngKind = "Marsaglia-Multicarry", 
                                          rngNormalKind = "Kinderman-Ramage")
        
        source('~/Documents/Trafin/lovy/mixr/mixr.R')
        
        
        testResult <- runTestSuite(testsuite.mixr)
        
        print(testResult)
        
}