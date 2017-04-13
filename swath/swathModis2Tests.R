
context('MaxAot function')

test_that("it does what it's supposed to do", {
    stub(complicated_function, "something_long_and_complicated") <- function(...) "[1,2,3,4,5]"
    expect_identical(complicated_function(), "test")
})