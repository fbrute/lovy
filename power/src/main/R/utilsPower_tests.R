# utilsPower_tests.R
#
#


describe("getParamsPower()",{
    paramsLists <- getParamsPower()
    it("expects the lower cut pressure to be greater than the higher cut pressure", {
       expect_true(paramsList$lower_cut_pressure > paramsList$higher_cut_pressure)
   })
})