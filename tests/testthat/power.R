context("power calculation from soundings already in MariaDB")

test_that("get a good list of parameters", {
    source("~/Documents/trafin/lovy/power/power.R")
    lparams = getParams(dbg=TRUE)
    expect_equal(length(lparams), 5)
})

test_that("we can get the sounding data for 1973-01-01 => 1973-02-01", {
    dbg=TRUE
    source("~/Documents/trafin/lovy/power/power.R")
    lparams = getParams(dbg)
    soundingdata = getData("sounding",lparams, dbg)
    expect_equal(length(soundingdata$date) , 246)
})