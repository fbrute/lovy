from qgis.core import *

def run():
    # supply path to qgis install location
    QgsApplication.setPrefixPath("/usr", True)

    # create a reference to the QgsApplication, setting the
    # second argument to False disables the GUI
    qgs = QgsApplication([], False)

    # load providers
    qgs.initQgis()


    print("I ran")

    qgs.exitQgis()

run()