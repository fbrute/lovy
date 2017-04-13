# com.lovy.SwathModis project
from pyhdf import SD
import os.path, os,  numpy
import re

class GetCsvFromHdf:

    """ Get data from hdf files fo csv files """
    
    def __init__(self):

        """SDS (Scientific Dataset) Names of interest """

        #self.sdsarray = ("Latitude", "Longitude", "Optical_Depth_Land_And_Ocean" , "Effective_Optical_Depth_Average_Ocean",
        #self.sdsarray = ("Latitude", "Longitude", "Effective_Optical_Depth_Average_Ocean")
        self.sdsarray = ("Latitude", "Longitude", "Optical_Depth_Land_And_Ocean")
        #self.sdsarray = ("Latitude", "Longitude", "Effective_Optical_Depth_Average_Ocean","Optical_Depth_Land_And_Ocean", "Corrected_Optical_Depth_Land" )
        # 500nm by default
        
        #aot_length = raw_input("Enter aot length (1 for 500, 2 for 675, 3 for 870) : ")
        aot_length = 550 

        if aot_length == 550: # 550 for modis
            aot_indice = 1
        elif aot_length == 675: # 660 for modis
            aot_indice = 2
        elif aot_length == 870:   # 860 for  modis
            aot_indice = 3
        elif aot_length == 1020: # 1240 for modis
            aot_indice = 4
        elif aot_length == 440 : # 470 for modis
            aot_indice = 0

        #sat_origin = raw_input("T for TERRA or A for AQUA")
        sat_origin = 'T'

        if sat_origin == 'T':
          self.sat_origin = 'TERRA'

        if sat_origin == 'A':
          self.sat_origin = 'AQUA'

        self.aot_length = aot_length 
        # Data indice
        self.aot_indice = aot_indice 
    
    def setFileNames(self):
        """ Retrieve the names of the hdf files """
        import glob

        # Set path to 1st june 2012 only
        #self.filenames = glob.glob('*A2012153*.hdf')

        #if self.sat_origin == 'TERRA':
          #os.chdir("/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MOD04_L2/swathmodis/hdf")
        #if self.sat_origin == 'AQUA':
        #  os.chdir("/Users/france-norbrute/Documents/trafin/fouyol/recherche/data/modis/MYD04_L2/swathmodis/hdf")
        os.chdir(".")

        #print os.getcwd()
        self.filenames = glob.glob('*A2015*.hdf')
        #self.filename = filename 
        #self.sdsarray = ("Latitude", "Longitude","Optical_Depth_Land_And_Ocean", "Number_Pixels_Used_Ocean", "Quality_Assurance_Ocean")

    def get_overpass_hour(self,filename):
        """ Get satellite overpass hour """
        if self.sat_origin == 'TERRA':
          hour_search = re.search('MOD04_3K.A2015\d{3}\.(\d{4})\.', filename , re.IGNORECASE)
        if self.sat_origin == 'AQUA':
          hour_search = re.search('MYD04_3K.A2015\d{3}\.(\d{4})\.', filename , re.IGNORECASE)
        return hour_search.group(1)

    def get_julian_day(self,filename):
        """ Get julian day """
        if self.sat_origin == 'TERRA':
          julian_day_search = re.search('MOD04_3K.A2015(\d{3})\.', filename , re.IGNORECASE)
        if self.sat_origin == 'AQUA':
          julian_day_search = re.search('MYD04_3K.A2015(\d{3})\.', filename , re.IGNORECASE)
        return int(julian_day_search.group(1))
        
    def june_dataloop(self):
        for filename in self.filenames:
            if self.get_julian_day(filename) in range(1,367):
                for sdsname in self.sdsarray:
                    data = self.getEDR(filename, sdsname)
                    self.saveDataToCsv(filename, sdsname, data)

    def dataloop(self):
        for filename in self.filenames:
            for sdsname in self.sdsarray:
                data = self.getEDR(filename, sdsname)
                self.saveDataToCsv(filename, sdsname, data)
                #self.saveDataToDB(filename, sdsname, data)

    def getEDR(self,filename, sdsname):

        """ Get from hdf relevant EDR """

        hdf=SD.SD(filename)
        sds=hdf.select(sdsname)
        data=sds.get()
            
        # 550 nm for Land 
        #if sdsname in  ("Corrected_Optical_Depth_Land", "Number_Pixels_Used_Land"):
        #    data = data[1]

        # 550 [1] or 860 nm [3] for Ocean
        if sdsname in  ("Effective_Optical_Depth_Average_Ocean","Corrected_Optical_Depth_Land"):
            data = data[self.aot_indice]

        #if sdsname in  ("Number_Pixels_Used_Ocean"):
    
        data = data.reshape(data.shape[1],data.shape[0])

        return data

        #self.data = data.reshape(data.shape[1],data.shape[0])
        #self.saveDataToCsv(filename, sdsname)
    
    def saveDataToCsv(self,filename, sdsname, data):
        """ Csv to be imported in R """
        #outputcsv = os.path.splitext(filename)[0]+ "_" + sdsname + ".csv" 
        #outputcsv = os.path.join(os.getcwd(), "csv" + str(self.aot_length) , sdsname + "_" + str(self.get_julian_day(filename)) +
        outputcsv = os.path.join(os.getcwd(), "csv" + str(self.aot_length) , sdsname + "_" + ( "%03d" % self.get_julian_day(filename) ) +
                     "_" + self.get_overpass_hour(filename) + ".csv" )

        #import pdb; pdb.set_trace()
        #f = open(outputcsv, 'wt', encoding='utf-8')
        print(outputcsv)
        print("... saving data ... to .. csv");
        numpy.savetxt(outputcsv, data, delimiter=",")
        #f.write(self.data)
        #outputcsv.close()


 
