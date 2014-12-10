library(RUnit)

testsuite.dusty <- defineTestSuite("dusty", 
                                   dirs = file.path(paste(getwd(),
                                "/dustydays",sep="")),
                                testFileRegexp = "^runit.+\\.R", 
                                testFuncRegexp = "^test.+", 
                                rngKind = "Marsaglia-Multicarry", 
                                rngNormalKind = "Kinderman-Ramage")

source('~/Documents/Trafin/lovy/dustydays/dusty.R')


testResult <- runTestSuite(testsuite.dusty)
