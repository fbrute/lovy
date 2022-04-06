#!/usr/bin/env python
import sys, os, functools, operator

def main(argv):
    dates2String = Dates2String(sys.argv[1])
    stringOfDates = dates2String.getStringOfDates()
    print(stringOfDates)

class Dates2String:

    """ Take a vector of dates in csv file, and convert them to a string """
    
    def __init__(self, filename):

        """ construct the object"""

        # the source file for the dates is supposed to exist
        if os.path.exists(filename):
            self.datesList = open(filename).readlines()
        else:
            print('File %s does not exists !' % filename)
            sys.exit(2)
        
        self.filename = filename
        self.outfilename = self.filename.split(".")[0] + '.txt'


    def getStringOfDates(self):
        # we strip the '\n' with rstrip
        self.stringOfDates = functools.reduce(operator.concat, [line.rstrip()+' ' for line in self.datesList])
        return(self.stringOfDates)

    def toFile(self):
        self.outfilename = self.filename.split(".")[0] + '.txt'
        self.outfile = open(self.outfilename,'+a')
        self.outfile.write(self.stringOfDates)
        self.outfile.close()
        
        

if __name__ == "__main__":
   main(sys.argv[1:]) 
