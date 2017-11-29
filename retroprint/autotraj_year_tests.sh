#!/usr/bin/env sh

source autotraj_year.sh

@test "check if a year is bissectile" {
    [ "$bissect" = 1 ]
}

### acceptanceTest.sh ###
 
function testItCanCheckIfAYearIsBissectile () {
    isbissectile 2012 bissect 
    assertTrue 1 $bissect
}
 
## Call and Run all Tests
. "../shunit2-2.1.6/src/shunit2"
