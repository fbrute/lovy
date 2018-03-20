#!/usr/bin/env python
import unittest, sys, os

#print sys.path
sys.path.append("../..")

from Dates2String import Dates2String

class TestDates2String(unittest.TestCase):

    def setUp(self):
        self.Dates2String = Dates2String('test_file_of_dates.csv')

    def test_getStringOfDates(self):
        stringOfDates = self.Dates2String.getStringOfDates()
        self.assertEqual(len(stringOfDates) ,  3*11)
    
    def test_toFile(self):
        stringOfDates = self.Dates2String.getStringOfDates()
        self.Dates2String.toFile()

        file = open(self.Dates2String.outfilename)
        strOfDates = file.readline()
        self.assertEqual(len(strOfDates), 3*11)
 
if __name__ == '__main__':
        unittest.main()

