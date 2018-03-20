#!/usr/bin/env ksh

testControl()
{
  assertEquals 1 1
}

oneTimeSetUp() {
  # Load include to test.
  . ./multi_days.inc
}

. ~/bin/shunit2/shunit2
