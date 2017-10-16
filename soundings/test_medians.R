library(testthat)

setwd ("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundings")
source("medians.R")

test_that("simulation() is correctly built", {
    months = c(1,12,2)
    
    rm(period)
    expect_error( simulation(), "Error in simulation() : Please specify a period" , fixed = TRUE)
    
    period = list(startDate = "2005-01-01")
    expect_error( simulation(period), "Error in simulation(period) : Please specify a season" , fixed = TRUE)
    
    expect_error( simulation(period, season), "Error in simulation(period,season) : Wrong number of dates for period" , fixed = TRUE)
})
