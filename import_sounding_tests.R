# Test the isalcal.R file

dbg = T

library("testthat")
source("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/import_sounding.R")

describe("import_sounding.R", {
    describe("(getCape)", {
        
        text = "</pre><h3>Station information and sounding indices</h3><pre>                         Station identifier: TFFR
                             Station number: 78897
        Observation time: 120801/1200
        Station latitude: 16.26
        Station longitude: -61.51
        Station elevation: 11.0
        Showalter index: 6.17
        Lifted index: -4.32
        LIFT computed using virtual temperature: -4.84
        SWEAT index: 94.80
        K index: 16.10
        Cross totals index: 11.70
        Vertical totals index: 26.70
        Totals totals index: 38.40
        Convective Available Potential Energy: 1072.58
        CAPE using virtual temperature: 1292.61
        Convective Inhibition: -12.34
        CINS using virtual temperature: -6.00
        Equilibrum Level: 175.72
        Equilibrum Level using virtual temperature: 174.76
        Level of Free Convection: 901.78
        LFCT using virtual temperature: 914.53
        Bulk Richardson Number: 118.89
        Bulk Richardson Number using CAPV: 143.28
        Temp [K] of the Lifted Condensation Level: 294.03
        Pres [hPa] of the Lifted Condensation Level: 930.36
        Mean mixed layer potential temperature: 300.18
        Mean mixed layer mixing ratio: 17.06
        1000 hPa to 500 hPa thickness: 5764.00
        Precipitable water [mm] for entire sounding: 37.64
        </pre>
        "
        
        
        it("expects to return the right value for the CAPE Index", {
            expect_equal( getCape(text), 1292.61, tolerance = 0.01)
        })
        
    })
    
    describe("(getFileUrls)", {
        years <- 2001:2015
        months <- c("janvier","fevrier","mars") 
        rootPath <- "/data/soundings"   
        
        it("expects to return the right value for the number of files", {
            expect_equal( length(getFileUrls(years,months,rootPath)), 45)
        })
    })
        
})

