# com.lovy.SwathModis project

import unittest
import sys
import re
#print sys.path
#sys.path.append("../..")

from getcsvfromhdf import GetCsvFromHdf

class TestGetcsvFromHdfMethods(unittest.TestCase):

    def setUp(self):
        self.getcsv = GetCsvFromHdf()
        self.getcsv.setFileNames()


       
    #def test_EODBO(self):
    #    """ get data for Effective_Optical_Depth_Best_Ocean """
    #    filename = self.getcsv.filenames[0]
    #    sdsname = "Effective_Optical_Depth_Best_Ocean"
    #    data = self.getcsv.getEDR(filename, sdsname)
    #    # Choose 0.55 (2nd value cited in Modis)
    #    print data
    #    print data.shape
    #    self.getcsv.saveDataToCsv(filename, sdsname, data)

    #def test_NPUL(self):
    #    """ get data for Number_Pixels_Used_Land """
    #    filename = self.getcsv.filenames[0]
    #    sdsname = "Number_Pixels_Used_Land"
    #    data = self.getcsv.getEDR(filename, sdsname)
    #    # Choose 0.55 (2nd value cited in Modis)
    #    print data
    #    print data.shape
    #    self.getcsv.saveDataToCsv(filename, sdsname, data)

    def test_dataloop(self):
        """ extract all datasets for one hdf file """
        #self.getcsv.june_dataloop() 
        self.getcsv.dataloop() 
      
if __name__ == '__main__':
        unittest.main()

#getcsv = GetCsvFromHdf() 
#getcsv.getFileNames()
#expect(getcsv.sdsarray).to.have("Latitude")
