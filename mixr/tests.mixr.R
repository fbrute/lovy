#context("Checking mixr mean calculation")


test_that("month to get the mean from is numeric",
{
        mean = meanForAMonth(1)
        expect_that(mean > 0, is_true())        
}
)

test.meanForAMonth <- function(month = 1) {
        checkTrue( month %in% 1:12)
        
        
        
}