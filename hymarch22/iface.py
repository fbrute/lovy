from config import Config
from pathlib import Path
from qgis.core import (QgsVectorLayer, QgsProject)


country_world_shp_file_path = "/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/retros_path/Countries_WGS84/Countries_WGS84.shp"


# get the path to the shapefile e.g. /home/project/data/ports.shp
path_to_world_layer = country_world_shp_file_path 

# The format is:
# vlayer = QgsVectorLayer(data_source, layer_name, provider_name)

vlayer = QgsVectorLayer(path_to_world_layer, "Airports layer", "ogr")
if not vlayer.isValid():
    print("Layer failed to load!")
else:
    QgsProject.instance().addMapLayer(vlayer)