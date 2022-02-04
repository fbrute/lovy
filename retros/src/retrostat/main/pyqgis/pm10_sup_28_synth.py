from qgis.core import (
  QgsApplication,
  QgsDataSourceUri,
  QgsCategorizedSymbolRenderer,
  QgsClassificationRange,
  QgsPointXY,
  QgsProject,
  QgsExpression,
  QgsField,
  QgsFields,
  QgsFeature,
  QgsFeatureRequest,
  QgsFillSymbol,
  QgsFeatureRenderer,
  QgsGeometry,
  QgsLayoutItemPolygon,
  QgsLayoutItemLabel,
  QgsLayoutItemMarker,
  QgsGraduatedSymbolRenderer,
  QgsMarkerLineSymbolLayer,
  QgsMarkerSymbol,
  QgsSimpleMarkerSymbolLayer,
  QgsSimpleMarkerSymbolLayerBase,
  QgsSingleSymbolRenderer,
  QgsMessageLog,
  QgsRectangle,
  QgsRendererCategory,
  QgsRendererRange,
  QgsSymbol,
  QgsVectorDataProvider,
  QgsVectorLayer,
  QgsVectorFileWriter,
  QgsWkbTypes,
  QgsSpatialIndex,
)

from qgis.core.additions.edit import edit

from qgis.PyQt.QtGui import (
    QColor,
)
from qgis import *
from qgis.core import QgsProject, QgsVectorLayer, QgsPalLayerSettings, QgsTextBufferSettings, QgsLayoutPoint
from qgis.core import QgsRuleBasedLabeling,QgsTextFormat,QgsField, QgsProperty, QgsPropertyCollection, QgsExpression
from qgis.core import QgsPrintLayout, QgsLayoutItemMap, QgsLayoutSize, QgsUnitTypes, QgsRectangle, QgsLayoutItemMapGrid
from qgis.core import QgsLayoutItemShape, QgsPoint, QgsLayoutMeasurement, QgsLayoutObject, QgsLayoutItemLabel
from qgis.core import QgsMessageLog, QgsMarkerSymbol, QgsLineSymbol

import sqlite3

import string

import math


from PyQt5.QtWidgets import QApplication, QWidget, QInputDialog, QLineEdit

from PyQt5.QtCore import QVariant, Qt
import qgis.utils
import os, sys, re

from qgis.utils import iface

import PyQt5
from PyQt5.QtGui import QFont, QColor

country_world_shp_file_path = "/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/retros_path/Countries_WGS84/Countries_WGS84.shp"
#canvas = qgis.utils.iface.mapCanvas()
# print(canvas.size())
sys.path.append("/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/main/pyqgis")
from colors import BtsColors
from shapes import BtsShapes
from gates import Gate, Gates

class BtsLoad:
  def __init__(self, data_dir):
    """ build BtsLoad with a path directory """
    self.__initBts(data_dir)
    self.data_dir = data_dir
  
  def __initBts(self, data_dir):
    self.setBtsPathDir(data_dir)
    self.stations = {"mada","puer","karu"}
    station = self.setStation(data_dir)
    shp_files_paths = self.__retrieveShpFilesPaths(data_dir)
    if (len(shp_files_paths) < 1): 
      raise AssertionError("No shape files in the path directory provided.")
    self.setShpFilesPaths(shp_files_paths)
    project = QgsProject.instance()
    self.setColors(BtsColors.getColors())
    self.setShapes(BtsShapes.getShapes())
    self.labels = {}
    self.setConfigForLabels()
    self.setConfigForStations()
    # initialize crs system (WSG84)
    self.setCrs(4326)
    self.__initProject(project)

  def setCrs(self,crs_id):
    self.crs = crs_id

  def getCrs(self):
    return self.crs

  def __initProject(self, project):
    self.setProject(project)
    self.loadShpFile(self.getProject(), country_world_shp_file_path, QColor("black"), None, None) 
    vlayer = iface.activeLayer()
    self.setVectorLayorColorToValue(vlayer, 0)
    self.setVectorLayerOpacityToValue(vlayer, 0.3)
    return self.getProject()

  def setStation(self, string_to_get_from):
    self.station = re.search(r"(puer|karu|mada)(?=/pm)", string_to_get_from)[0]
    if (not self.station):
      raise AssertionError("Station not found in path provided (should be puer,mada ork karu")
    return self.station

  def getStation(self):
    return self.station

  def getStations(self):
    return self.stations


  def setVectorLayorColorToValue(self, vlayer, value):
    single_symbol_renderer = vlayer.renderer()
    symbol = single_symbol_renderer.symbol()
    symbol.setColor(QColor(255,255,255,value))
    return vlayer

  def setVectorLayerOpacityToValue(self, vlayer, value):
    single_symbol_renderer = vlayer.renderer()
    symbol = single_symbol_renderer.symbol()
    symbol.setOpacity(value)
    return vlayer

  def setBtsPathDir(self, data_dir):
    self.bts_path_dir = data_dir
    return self.bts_path_dir

  def getBtsPathDir(self):
    return self.bts_path_dir
  
  def __retrieveShpFilesPaths(self, data_dir):
     return [shp_file for shp_file in os.listdir(data_dir) if shp_file[-3:] =='shp']

  def setShpFilesPaths(self, shp_files_paths):
    self.shp_files_paths = shp_files_paths
    return self.shp_files_paths

  def getShpFilesPaths(self):
    return self.shp_files_paths

  def setProject(self, project):
    self.project = project 
    return self.project

  def getProject(self):
    return self.project

  def setShapes(self, shapes):
    self.shapes = shapes

  def getShapes(self):
    return self.shapes

  def setColors(self, colors):
    self.colors = colors
    #if not(all([isinstance(color, QColor) for color in colors])):
    #  raise AssertionError("Colors are not of QColor type.")
    #return self.colors
  
  def getColors(self):
    return self.colors

  def getColor(self, gate):
    return self.colors[gate]

  def incColorIdx(self):
    idx = self.getColorIdx() + 1
    return (idx % (len(self.getColors())))
  
  def loadAllShpFiles(self, project, shp_files_paths, colors, shapes):
    for shp_file_path in shp_files_paths:
      #self.loadShpFile(self.getProject(), shp_file_path, colors[idx_color])
      self.loadShpFile(self.getProject(), shp_file_path, 
      colors[self.getShpName(shp_file_path)], shapes[self.getShpName(shp_file_path)],
      BtsShapes.getColors()[self.getShpName(shp_file_path)])
      # idx_color = ( idx_color + 1 ) % len(colors)

  def getShpBasename(self, shp_file_path):
    return(os.path.basename(shp_file_path))

  def getShpName(self, shp_file_path):
    return os.path.basename(shp_file_path)[0:-4]
  
  def getPicnum(self, string_to_get_from):
    picnum = re.search(r"(\d+)(?=\.shp)", string_to_get_from)[0]
    return picnum

  def setPm10Values(self):
    import sqlite3
    conn = sqlite3.connect('pm10_synth.db')
    c = conn.cursor()
    # Create table
    c.execute('''DROP TABLE IF EXISTS pm10''')
    c.execute('''CREATE TABLE pm10 
              (gate text, station text, percent real, mean real, std real)''')

    seeds = [
      ('nwap' , 'puer', 41.1, 44.2, 16.8),
      ('swap' , 'puer',  8.7, 44.0, 21.0),
      ('neap' , 'puer',  37.3, 37.8, 11.4),
      ('sa'   , 'puer',   8.0, 43.6, 19.7),
      ('north', 'puer',   4.9, 44.4, 16.9),
      ('nwap' , 'mada',  52.7, 47.5, 19.4),
      ('swap' , 'mada',  10.2, 48.9, 18.1),
      ('neap' , 'mada',  24.8, 40.5, 12.9),
      ('sa'   , 'mada',  10.2, 44.4, 14.2),
      ('north', 'mada',   2.1, 37.1,  8.5),
      ('nwap' , 'karu',  52.7, 44.4, 15.0),
      ('swap' , 'karu',  8.5,  48.1, 14.9),
      ('neap' , 'karu',  30.1, 40.7, 12.0),
      ('sa'   , 'karu',   6.9, 41.8,  9.8),
      ('north', 'karu',   1.8, 34.4,  5.6)
    ]
      
    c.executemany('INSERT INTO pm10 VALUES (?,?,?,?,?)', seeds)

    conn.commit()
    conn.close()

 
  def getLayerFromPath(self,shp_file_path):
    return QgsVectorLayer(os.path.join(self.getBtsPathDir(), shp_file_path), self.getShpBasename(shp_file_path), "ogr")

  # def shpFileAddAttribute(self,vlayer, attribute, attribute_value):

  #   if vlayer.startEditing():
  #     vlayer.addAttribute(QgsField("percent", QVariant.Double))
  #     vlayer.addAttribute(QgsField("mean", QVariant.Double))
  #     vlayer.addAttribute(QgsField("std", QVariant.Double))

  #     QgsMessageLog.logMessage(layer)

  #     if vlayer.changeAttributeValue(0,1,int(self.getPicnum(shp_file_path))):
  #       vlayer.updateFields()
  #       vlayer.commitChanges()
  #   return vlayer

  def addLabelToGateLayout(self, layout, gate, config):
    item_label = QgsLayoutItemLabel.create(layout)
    item_label.setText(gate.name)
    #symbol = item_label.symbol()
    #symbol.setColor(QColor(255,0,0,10))

    pc = QgsPropertyCollection("dataDefinedProperties")
    # position the label à the end of the trajectory (source)
    prop=QgsProperty()
    prop.setField("X")
    offset_x = 0
    x = offset_x + config['x0'] - (abs(gate.west) * config['deg_to_mm'])
    prop.setStaticValue(x)
    pc.setProperty(QgsLayoutObject.PositionX, prop)

    prop.setField("Y")
    offset_y = -3
    y = offset_y + config['y0'] - (gate.north * config['deg_to_mm'])
    prop.setStaticValue(y)
    pc.setProperty(QgsLayoutObject.PositionY, prop)

    prop.setField("Width")
    prop.setStaticValue(12)
    pc.setProperty(QgsLayoutObject.ItemWidth, prop)

    prop.setField("Height")
    prop.setStaticValue(7)
    pc.setProperty(QgsLayoutObject.ItemHeight, prop)

    prop.setField("Opacity")
    prop.setStaticValue(config['opacity'])
    pc.setProperty(QgsLayoutObject.Opacity, prop)

    item_label.setDataDefinedProperties(pc)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.PositionX)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.PositionY)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.ItemWidth)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.ItemHeight)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.Opacity)

    layout.addLayoutItem(item_label)



  def addGateToLayout(self,layout, gate, config):
    item_gate = QgsLayoutItemShape.create(layout)
    item_gate.setShapeType(QgsLayoutItemShape.Rectangle)
    #item_gate.setReferencePoint(210,52)

    symbol = item_gate.symbol()

    symbol.setColor(config['color'])

    pc = QgsPropertyCollection("dataDefinedProperties")
    # position the label à the end of the trajectory (source)
    prop=QgsProperty()
    prop.setField("X")

    x =config['x0'] - (abs(gate.west) * config['deg_to_mm'])
    x = prop.setStaticValue(x)
    pc.setProperty(QgsLayoutObject.PositionX, prop)

    prop.setField("Y")
    y = config['y0'] - (gate.north * config['deg_to_mm'])
    prop.setStaticValue(y)
    pc.setProperty(QgsLayoutObject.PositionY, prop)

    prop.setField("Width")
    prop.setStaticValue(gate.width() * config["deg_to_mm"])
    pc.setProperty(QgsLayoutObject.ItemWidth, prop)

    prop.setField("Height")
    prop.setStaticValue(gate.height() * config["deg_to_mm"])
    pc.setProperty(QgsLayoutObject.ItemHeight, prop)

    prop.setField("Opacity")
    prop.setStaticValue(config['opacity'])
    pc.setProperty(QgsLayoutObject.Opacity, prop)

    #item_gate.refreshDataDefinedProperty(prop)

    item_gate.setDataDefinedProperties(pc)
    item_gate.refreshDataDefinedProperty(QgsLayoutObject.PositionX)
    item_gate.refreshDataDefinedProperty(QgsLayoutObject.PositionY)
    item_gate.refreshDataDefinedProperty(QgsLayoutObject.ItemWidth)
    item_gate.refreshDataDefinedProperty(QgsLayoutObject.ItemHeight)
    item_gate.refreshDataDefinedProperty(QgsLayoutObject.Opacity)

    #item_gate.refreshDataDefinedProperty(item_gate.dataDefinedProperties())

    item_gate.setCornerRadius(QgsLayoutMeasurement(3))

    #item_gate.updateBoundingRect()

    layout.addLayoutItem(item_gate)

  def addGatesToLayout(self, layout, config):
    pass

  def getGateConfig(self):
    pass


  def getGatePuerConfig(self):
    config = {}
    # extent rectangle
    config['rect'] = QgsRectangle(-70, 0, 25, 45)
    config['deg_to_mm'] = 2.71
    # x0 in mm
    #config['x0'] = 242 
    config['x0'] = 206 
    # y0 in mm
    #config['y0'] = 84
    config['y0'] = 138 
    config['opacity'] = 10
    return config

  def getGateKaruConfig(self):
    config = {}
    # extent rectangle
    config['rect'] = QgsRectangle(-65, -5, 20, 45)
    config['deg_to_mm'] = 3.04
    # x0 in mm
    #config['x0'] = 242 
    config['x0'] = 214 
    # y0 in mm
    #config['y0'] = 84
    config['y0'] = 169 
    config['opacity'] = 10
    return config

  def getDefaultGateConfig(self):
    config = {}
    # extent rectangle
    config['rect'] = QgsRectangle(-82.583, -10.331, 8.813, 43.921)
    config['deg_to_mm'] = 3.04
    # x0 in mm
    #config['x0'] = 242 
    config['x0'] = 214 
    # y0 in mm
    #config['y0'] = 84
    config['y0'] = 169 
    config['opacity'] = 10
    return config

  
  def getGatesConfig(self, station):
    if station == "karu":
      return self.getGateKaruConfig()
    if station == "puer":
      return self.getGatePuerConfig()
    if station == "mada":
      return self.getGateMadaConfig()


  def createMap(self,project, layout_name):
    # get config per station
    #config = self.getGatesConfig(self.getStation()) 
    config = self.getDefaultGateConfig() 
    #get a reference to the layout manager
    manager = project.layoutManager()
    #make a new print layout object
    layout = QgsPrintLayout(project)
    #needs to call this according to API documentaiton
    layout.initializeDefaults()
    #cosmetic
    #layout.setName('console')
    layout.setName(layout_name)
    #add layout to manager
    manager.addLayout(layout)
    #create a map item to add
    #item_map = QgsLayoutItemMap.create(layout)
    item_map = QgsLayoutItemMap(layout)
    #using ndawson's answer below, do this before setting extent
    item_map.attemptMove(QgsLayoutPoint(5,5, QgsUnitTypes.LayoutMillimeters))
    item_map.attemptResize(QgsLayoutSize(260,190, QgsUnitTypes.LayoutMillimeters))
    # create rectangle for extent
    #rect = QgsRectangle(-82.583, -10.331, 8.813, 43.921)
    rect = config['rect']
    #set an extent
    item_map.setExtent(rect)

    pc = QgsPropertyCollection("dataDefinedProperties")
    prop=QgsProperty()
    prop.setField("X")
    prop.setStaticValue(15)
    pc.setProperty(QgsLayoutObject.PositionX, prop)

    prop=QgsProperty()
    prop.setField("Y")
    prop.setStaticValue(15)
    pc.setProperty(QgsLayoutObject.PositionY, prop)

    item_map.setDataDefinedProperties(pc)
    item_map.refreshDataDefinedProperty(QgsLayoutObject.PositionX)
    item_map.refreshDataDefinedProperty(QgsLayoutObject.PositionY)
    
    #add the map to the layout
    layout.addLayoutItem(item_map)    
    #item_map.resizeItems(1)
    item_map.grid().setFramePenColor(QColor(0,0,241,46))
    item_map.grid().setFrameFillColor1(QColor(0,0,241,46))
    item_map.grid().setFrameFillColor2(QColor(255,255,255,46))

    item_map.grid().setEnabled(True)  
    item_map.grid().setIntervalX(10)  
    item_map.grid().setIntervalY(10)  
    item_map.grid().setAnnotationEnabled(True) 
    item_map.grid().setFrameStyle(1) 
    item_map.grid().setGridLineColor(QColor(0,0,241,40))  
    item_map.grid().setGridLineWidth(0.66)
    #item_map.grid().setBlendMode(1)

    item_map.grid().setAnnotationPrecision(0)  
    item_map.grid().setAnnotationFrameDistance(1)  
    item_map.grid().setAnnotationFontColor(QColor(0, 0, 241, 66)) 

    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.ShowAll, QgsLayoutItemMapGrid.Right)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Right)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Horizontal, QgsLayoutItemMapGrid.Right)

    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.ShowAll, QgsLayoutItemMapGrid.Top)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Top)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Horizontal, QgsLayoutItemMapGrid.Top)

    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.ShowAll, QgsLayoutItemMapGrid.Left)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Left)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Horizontal, QgsLayoutItemMapGrid.Left)

    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.ShowAll, QgsLayoutItemMapGrid.Bottom)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Bottom)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Horizontal, QgsLayoutItemMapGrid.Bottom)

    item_map.updateBoundingRect()
    
    layout.addLayoutItem(item_map)
    [ self.addLabelToLayout(layout, gate, self.getConfigForLabels(self.getStation(), gate)) for gate in self.getGates()]

    [ self.addStationShapeToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]

    [ self.addStationShapeToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]

    [ self.addStationLabelToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]
  
  def setConfigForStations(self):
    mada = {
        'x_shape'    : 77.22,
        'y_shape'    : 99.15,
        'offset_horizontal': 16,
        'offset_vertical': 3,
        'name' : 'MAR',
        'color': 'magenta',
        'text_color': 'magenta',
        'shape': 'diamond',
        'opacity': 100,
        'size': '8' 
      }
    mada['x_label'] =     mada['x_shape'] - mada['offset_horizontal']
    mada['y_label'] =     mada['y_shape'] - mada['offset_vertical'] 

    puer = {
        'x_shape'    : 61.23,
        'y_shape'    : 88.64,
        'offset_horizontal': 12,
        'offset_vertical': 3,
        'name' : 'PR',
        'color': 'yellow',
        'text_color': 'black',
        'shape': 'square',
        'opacity': 100,
        'size': '6' 
      }
    puer['x_label'] =  puer['x_shape'] - puer['offset_horizontal']
    puer['y_label'] =  puer['y_shape'] - puer['offset_vertical']

    karu = {
        'x_shape'    : 75.85,
        'y_shape'    : 95.04,
        'offset_horizontal': 15,
        'offset_vertical': 3,
        'name' : 'GPE',
        'color': 'orange',
        'text_color': 'orange',
        'shape': 'circle',
        'opacity': 100,
        'size': '6' 
      }
    karu['x_label'] =     karu['x_shape'] - karu['offset_horizontal']
    karu['y_label'] =     karu['y_shape'] - karu['offset_vertical']
    self.config_for_stations = {'mada': mada, 'karu': karu, 'puer': puer}
  
  def getConfigForStations(self,station):
    return self.config_for_stations[station]

  def setConfigForLabels(self):
    mada = {
      'north': {
        'x'    : 38.83,
        'y'    : 34.64,
      },
      'neap': {
        'x'    : 89.90,
        'y'    : 58.94,
      },
      'nwap': {
        'x'    : 184.39,
        'y'    : 67.36,
      },
      'sa': {
        'x'    : 45.22,
        'y'    : 136.63,
      },
      'swap': {
        'x'    : 142.56,
        'y'    : 125.48,
      }
    }
    karu = {
      'north': {
        'x'    : 23.91,
        'y'    : 36.38,
      },
      'neap': {
        'x'    : 92.68,
        'y'    : 55.45,
      },
      'nwap': {
        'x'    : 128.82,
        'y'    : 96.08,
      },
      'sa': {
        'x'    : 84,
        'y'    : 150,
      },
      'swap': {
        'x'    : 128,
        'y'    : 117,
        
      }
    }
    puer = {
      'north': {
        'x'    : 27.47,
        'y'    : 38.01,
      },
      'neap': {
        'x'    : 91.38,
        'y'    : 55.74,
      },
      'nwap': {
        'x'    : 115.82,
        'y'    : 99.08,
      },
      'sa': {
        'x'    : 32.58,
        'y'    : 127.48,
      },
      'swap': {
        'x'    : 142.10,
        'y'    : 122.74,
      }
    }
    
    self.config_for_labels = {'mada': mada, 'puer': puer, 'karu': karu}

    
  def getConfigForLabels(self, station, gate):
    return self.config_for_labels[station][gate]


  def getGates(self):
    return ['nwap','swap','neap','north', 'sa']

  def addLabelToLayout(self, layout, gate, config):
    #create a layout item (a label in this case)
    label = QgsLayoutItemLabel(layout)    
    #set what the text will be
    print("#################################")
    print(config)
    print("#################################")
    label.setText(self.getLabelPm10(gate))
    #change font style and size (optional)
    font = QFont("Arial", 14)
    font.setBold(True)
    label.setFont(font)
    label.setFontColor(self.getColor(gate))

    #set size of label item. this step seems a little pointless to me but it doesn't work without it
    label.adjustSizeToText() 

    #add map_label to your layout
    layout.addLayoutItem(label)

    #another thing you probably want to do is specify where your label is on the print layout
    label.attemptMove(QgsLayoutPoint(config['x'], config['y'], QgsUnitTypes.LayoutMillimeters))
  
  def shpFileSetCrs(self, vlayer, crs_value):
    crs = vlayer.crs()
    crs.createFromId(crs_value)
    vlayer.setCrs(crs)
    return vlayer

  
  def getSql(self, column):
    return 'SELECT ' + column + ' FROM pm10 WHERE station=? and gate=?'

  # def getValue(self, get_from):
  #   get_from = str(get_from)
  #   return re.search(r"(\d+\.\d+)", get_from)[0]

  def getValue(self,get_from):
    return str(get_from)[1:-2] 
    #return str(get_from)

  def getGateValue(self, station, gate, column):
    import sqlite3
    conn = sqlite3.connect('/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/pm10_synth.db')
    sql_values = (station, gate,)
    c = conn.cursor()
    c.execute(self.getSql(column), sql_values)
    value = c.fetchone()
    conn.close()
    return value

  def addLabelPm10(self,key,value):
    self.labels[key] = value
  
  def getLabelPm10(self, key):
    return self.labels[key]

  def loadShpFile(self, project, shp_file_path, color, shape, colorShape):

    gate = self.getShpName(shp_file_path)
    value = self.getGateValue(self.getStation(), gate, 'percent')
    percent = str(value)[1:-2]

    value = self.getGateValue(self.getStation(), gate, 'mean')
    mean = str(value)[1:-2]

    value = self.getGateValue(self.getStation(), gate, 'std')
    std = str(value)[1:-2] 

    #label = f'{gate.upper()}:{percent}% PM10= {mean} \u00B1{std} \u00B5g.m\u207B\N{SUPERSCRIPT THREE}'
    label = f'{gate.upper()}:{percent}% PM10= {mean} \u00B1{std} \u00B5g.m\u207B\u00b3'
    self.addLabelPm10(gate, label)

    layer = self.getLayerFromPath(os.path.join(self.getBtsPathDir(), shp_file_path))
    layer = self.shpFileSetCrs(layer, self.getCrs())


    #symbol = QgsLineSymbol.createSimple({'name': 'square', 'color': 'blue',  'interval': '3'})
    #layer.renderer().setSymbol(symbol)
    # show the change
    #layer.renderer().symbol().setColor(color)
    # Base style.    

    if gate in self.getGates():
      line_symbol = QgsLineSymbol()

      # Create an marker line_symbol 
      marker_line = QgsMarkerLineSymbolLayer()
      marker_line.setInterval(5)

      # Configure the marker.
      simple_marker = QgsSimpleMarkerSymbolLayer()
      simple_marker.setShape(shape)
      #size = math.ceil(float(percent)/100*8)
      size = 3 
      simple_marker.setSize(size)
      simple_marker.setAngle(180)
      simple_marker.setColor(color)
      # The marker has its own symbol layer.
      marker = QgsMarkerSymbol()
      marker.changeSymbolLayer(0, simple_marker)

      # Add the layer to the marker layer.
      marker_line.setSubSymbol(marker)

      # Add a ligne to the symbols
      #line_simple = QgsLineSymbol.createSimple({ 'color': 'black' })

      # Finally replace the symbol layer in the base style.
      line_symbol.changeSymbolLayer(0, marker_line)
      #line_symbol.insertSymbolLayer(1, line_simple.symbolLayer(0))

      # Add the style to the line_symbol layer.        
      renderer = QgsSingleSymbolRenderer(line_symbol) 
      layer.setRenderer(renderer)
      layer.triggerRepaint()

      # Add a simple line
      #layer = iface.activeLayer()
      #line_simple = QgsLineSymbol.createSimple({ 'color': 'black' })
      #line_simple = QgsLineSymbol()
      #line_simple.setColor(color)
      #renderer = QgsLineSymbolRenderer(line_simple) 
      #layer.setRenderer(renderer)
      #layer.triggerRepaint()
      width =float(percent)/100*3
      if width < 0.2:
        width = 0.2
      simple_line = QgsApplication.symbolLayerRegistry().symbolLayerMetadata("SimpleLine").createSymbolLayer({
        'color': colorShape,
        'line_color': colorShape,
        'width' : f'{width}'
      })

      
      layer.renderer().symbol().appendSymbolLayer(simple_line)
      #layer.renderer().symbol().appendSymbolLayer(line_simple.symbolLayer(0))
      layer.triggerRepaint()
      #iface.layerTreeView().refreshLayerSymbology(layer.id())

    project.addMapLayer(layer, True)

  def addStationShapeToLayout(self,layout, config):
    item_shape = QgsLayoutItemMarker.create(layout)
    # # Configure the marker.
    # simple_marker = QgsSimpleMarkerSymbolLayer()
    # simple_marker.setShape(config['shape'])
    # #size = math.ceil(float(percent)/100*8)
    # size = 10 
    # simple_marker.setSize(size)
    # simple_marker.setAngle(180)
    # simple_marker.setColor(config['color'])
    # #item_shape.changeSymbolLayer(0, simple_marker)
    marker_symbol = QgsMarkerSymbol.createSimple({'name': config['shape'], 'color': config['color'], 'size': config['size']})

    item_shape.setSymbol(marker_symbol)
    #item_shape.setReferencePoint(210,52)

    symbol = item_shape.symbol()

    #symbol.setColor(config['color'])

    pc = QgsPropertyCollection("dataDefinedProperties")
    # position the label à the end of the trajectory (source)
    prop=QgsProperty()
    prop.setField("X")

    x =config['x_shape']
    x = prop.setStaticValue(x)
    pc.setProperty(QgsLayoutObject.PositionX, prop)

    prop.setField("Y")
    y = config['y_shape']
    prop.setStaticValue(y)
    pc.setProperty(QgsLayoutObject.PositionY, prop)

    prop.setField("Width")
    prop.setStaticValue(6)
    pc.setProperty(QgsLayoutObject.ItemWidth, prop)

    prop.setField("Height")
    prop.setStaticValue(6)
    pc.setProperty(QgsLayoutObject.ItemHeight, prop)

    prop.setField("Opacity")
    prop.setStaticValue(config['opacity'])
    pc.setProperty(QgsLayoutObject.Opacity, prop)

    #item_shape.refreshDataDefinedProperty(prop)

    item_shape.setDataDefinedProperties(pc)
    item_shape.refreshDataDefinedProperty(QgsLayoutObject.PositionX)
    item_shape.refreshDataDefinedProperty(QgsLayoutObject.PositionY)
    item_shape.refreshDataDefinedProperty(QgsLayoutObject.ItemWidth)
    item_shape.refreshDataDefinedProperty(QgsLayoutObject.ItemHeight)
    item_shape.refreshDataDefinedProperty(QgsLayoutObject.Opacity)

    #item_shape.refreshDataDefinedProperty(item_shape.dataDefinedProperties())

    #item_shape.setCornerRadius(QgsLayoutMeasurement(3))

    #item_shape.updateBoundingRect()

    layout.addLayoutItem(item_shape)
  
  def addStationLabelToLayout(self, layout, config):
    item_label = QgsLayoutItemLabel.create(layout)
    item_label.setText(config['name'])
    item_label.setFontColor(QColor(config['text_color']))
    font = QFont("Arial", 14)
    font.setBold(True)
    item_label.setFont(font)
    #set size of label item. this step seems a little pointless to me but it doesn't work without it
    item_label.adjustSizeToText() 
    #symbol = item_label.symbol()
    #symbol.setColor(QColor(255,0,0,10))

    pc = QgsPropertyCollection("dataDefinedProperties")
    # position the label à the end of the trajectory (source)
    prop=QgsProperty()
    prop.setField("X")
    x = config['x_label']
    prop.setStaticValue(x)
    pc.setProperty(QgsLayoutObject.PositionX, prop)

    prop.setField("Y")
    y = config['y_label']
    prop.setStaticValue(y)
    pc.setProperty(QgsLayoutObject.PositionY, prop)

    prop.setField("Width")
    prop.setStaticValue(12)
    pc.setProperty(QgsLayoutObject.ItemWidth, prop)

    prop.setField("Height")
    prop.setStaticValue(7)
    pc.setProperty(QgsLayoutObject.ItemHeight, prop)

    prop.setField("Opacity")
    prop.setStaticValue(config['opacity'])
    pc.setProperty(QgsLayoutObject.Opacity, prop)

    item_label.setDataDefinedProperties(pc)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.PositionX)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.PositionY)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.ItemWidth)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.ItemHeight)
    item_label.refreshDataDefinedProperty(QgsLayoutObject.Opacity)

    layout.addLayoutItem(item_label)


  def saveProject(self, project):
    project.write(os.path.join(self.data_dir,f"pm10_sup_28_synth_{self.getStation()}.qgs"))


def main():
  """ import bts with custom label color and position"""
  # set a unique id for layout
  import time
  layout_name = str(time.time())

  btsLoader = BtsLoad(f"/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/karu/pm10_sup_28_synth")
  # execute once the sql prepration 
  btsLoader.setPm10Values() 
  #btsLoader.loadShpFile(btsLoader.getProject(), btsLoader.getShpFilesPaths()[0], QColor("blue")) 

  btsLoader.loadAllShpFiles(btsLoader.getProject(), btsLoader.getShpFilesPaths(), btsLoader.getColors(), btsLoader.getShapes())

  #btsLoader.addLinesToSymbols(btsLoader.getProject(), BtsShapes.getColors())
  btsLoader.createMap(btsLoader.getProject(), layout_name)
  #btsLoader.createLayout()
  btsLoader.saveProject(btsLoader.getProject())


#  main()

# if __name__ == '__main__':

#   main()