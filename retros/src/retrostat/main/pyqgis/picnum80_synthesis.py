from qgis import *
from qgis.core import QgsProject, QgsVectorLayer, QgsPalLayerSettings, QgsTextBufferSettings
from qgis.core import QgsRuleBasedLabeling,QgsTextFormat,QgsField, QgsProperty, QgsPropertyCollection, QgsExpression
from qgis.core import QgsPrintLayout, QgsLayoutItemMap, QgsLayoutSize, QgsUnitTypes, QgsRectangle, QgsLayoutItemMapGrid
from qgis.core import QgsLayoutItemShape, QgsPoint, QgsLayoutMeasurement, QgsLayoutObject, QgsLayoutItemLabel

from PyQt5.QtCore import QVariant
import qgis.utils
import os, sys, re

from qgis.utils import iface

import PyQt5
from PyQt5.QtGui import QFont, QColor

data_dir = '/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/karu/picnums'
country_world_shp_file_path = "/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/data/retros_path/Countries_WGS84/Countries_WGS84.shp"
#canvas = qgis.utils.iface.mapCanvas()
# print(canvas.size())
sys.path.append("/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/main/pyqgis")
from colors import BtsColors
from gates import Gate, Gates

class BtsLoad:
  def __init__(self, data_dir):
    """ build BtsLoad with a path directory """
    self.__initBts(data_dir)
  
  def __initBts(self, data_dir):
    self.setBtsPathDir(data_dir)
    station = self.setStation(data_dir)
    shp_files_paths = self.__retrieveShpFilesPaths(data_dir)
    if (len(shp_files_paths) < 1): 
      raise AssertionError("No shape files in the path directory provided.")
    self.setShpFilesPaths(shp_files_paths)
    project = QgsProject.instance()
    colors = self.setColors(BtsColors.getColors())
    idx_color = self.setColorIdx(0)
    # initialize crs system (WSG84)
    self.setCrs(4326)
    self.__initProject(project)

  def setCrs(self,crs_id):
    self.crs = crs_id

  def getCrs(self):
    return self.crs

  def __initProject(self, project):
    self.setProject(project)
    self.loadShpFile(self.getProject(), country_world_shp_file_path, QColor("black")) 
    vlayer = iface.activeLayer()
    self.setVectorLayorColorToValue(vlayer, 0)
    self.setVectorLayerOpacityToValue(vlayer, 0.2)
    return self.getProject()

  def setStation(self, string_to_get_from):
    self.station = re.search(r"(puer|karu|mada)(?=/picnums)", string_to_get_from)[0]
    if (not self.station):
      raise AssertionError("Station not found in path provided (should be puer,mada ork karu")
    return self.station

  def getStation(self):
    return self.station


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

  def setColors(self, colors):
    self.colors = colors
    if not(all([isinstance(color, QColor) for color in colors])):
      raise AssertionError("Colors are not of QColor type.")
    return colors
  
  def getColors(self):
    return self.colors

  def setColorIdx(self,idx):
    self.colorIdx = idx

  def getColor(self, idx):
    return getColors()[idx]
  
  def getColorIdx(self):
    return self.colorIdx

  def incColorIdx(self):
    idx = self.getColorIdx() + 1
    return (idx % (len(self.getColors())))
  
  def loadAllShpFiles(self, project, shp_files_paths, colors, idx_color):
    for shp_file_path in shp_files_paths:
      self.loadShpFile(self.getProject(), shp_file_path, colors[self.])
      idx_color = ( idx_color + 1 ) % len(colors)
  
  def getShpBasename(self, shp_file_path):
    return(os.path.basename(shp_file_path))
  
  def getPicnum(self, string_to_get_from):
    picnum = re.search(r"(\d+)(?=\.shp)", string_to_get_from)[0]
    return picnum

  def getLayerFromPath(self,shp_file_path):
    return QgsVectorLayer(os.path.join(self.getBtsPathDir(), shp_file_path), self.getShpBasename(shp_file_path), "ogr")

  def shpFileAddAttribute(self,vlayer, attribute, attribute_value):
    if vlayer.startEditing():
      vlayer.addAttribute(QgsField("picnum", QVariant.Int))
      if vlayer.changeAttributeValue(0,1,int(self.getPicnum(shp_file_path))):
        vlayer.updateFields()
        vlayer.commitChanges()
    return vlayer

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
  
  def getGatesConfig(self, station):
    if station == "karu":
      return self.getGateKaruConfig()
    if station == "puer":
      return self.getGatePuerConfig()


  def createMap(self,project):
    # get config per station
    config = self.getGatesConfig(self.getStation()) 
    #get a reference to the layout manager
    manager = project.layoutManager()
    #make a new print layout object
    layout = QgsPrintLayout(project)
    #needs to call this according to API documentaiton
    layout.initializeDefaults()
    #cosmetic
    layout.setName('console')
    #add layout to manager
    manager.addLayout(layout)
    #create a map item to add
    item_map = QgsLayoutItemMap.create(layout)
    #using ndawson's answer below, do this before setting extent
    item_map.attemptResize(QgsLayoutSize(260,190, QgsUnitTypes.LayoutMillimeters))
    # create rectangle for extent
    #rect = QgsRectangle(-130, -5, 20, 45)
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
    item_map.grid().setEnabled(True)  
    item_map.grid().setIntervalX(5)  
    item_map.grid().setIntervalY(5)  
    item_map.grid().setAnnotationEnabled(True) 
    item_map.grid().setGridLineColor(QColor(0,0,0,20))  
    item_map.grid().setGridLineWidth(0.5)
    item_map.grid().setAnnotationPrecision(0)  
    item_map.grid().setAnnotationFrameDistance(1)  
    item_map.grid().setAnnotationFontColor(QColor(0, 0, 0, 30)) 
    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.HideAll, QgsLayoutItemMapGrid.Right)
    item_map.grid().setAnnotationDisplay(QgsLayoutItemMapGrid.HideAll, QgsLayoutItemMapGrid.Top)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Bottom)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Horizontal, QgsLayoutItemMapGrid.Bottom)
    item_map.grid().setAnnotationPosition(QgsLayoutItemMapGrid.OutsideMapFrame, QgsLayoutItemMapGrid.Left)
    item_map.grid().setAnnotationDirection(QgsLayoutItemMapGrid.Vertical, QgsLayoutItemMapGrid.Left)
    item_map.updateBoundingRect()
    
    layout.addLayoutItem(item_map)

    
    # transform from degrees to mm
    #config['deg_to_mm'] = 1.85
    # config['deg_to_mm'] = 3.35
    # # x0 in mm
    # #config['x0'] = 242 
    # config['x0'] = 216 
    # # y0 in mm
    # #config['y0'] = 84
    # config['y0'] = 149 
    # config['opacity'] = 10

    # idx_color = 0
    # colors = [QColor("red"), QColor("green"), QColor("blue"), QColor("magenta"), QColor("darkMagenta")]
    # for gate in Gates:
    #   config['color'] = colors[idx_color]
    #   self.addGateToLayout(layout, gate, config)
    #   idx_color = ( idx_color + 1 ) % len(colors)
    #[self.addGateToLayout(layout, gate, config)  for gate in Gates]
    #self.addGateToLayout(layout, Gates["NWAP"], config)

    config['opacity'] = 100
    [self.addLabelToGateLayout(layout, gate, config) for gate in Gates]
  
  def shpFileSetCrs(self, vlayer, crs_value):
    crs = vlayer.crs()
    crs.createFromId(crs_value)
    vlayer.setCrs(crs)
    return vlayer

  def loadShpFile(self, project, shp_file_path, color):
    vlayer = self.getLayerFromPath(os.path.join(self.getBtsPathDir(), shp_file_path))
    vlayer = self.shpFileSetCrs(vlayer, self.getCrs())

    project.addMapLayer(vlayer, True)

    vlayer = iface.activeLayer()
    if vlayer.startEditing():
      vlayer.addAttribute(QgsField("picnum", QVariant.Int))
      if vlayer.changeAttributeValue(0,1,int(self.getPicnum(shp_file_path))):
        vlayer.updateFields()
        vlayer.commitChanges()

    vlayer = iface.activeLayer()
    settings = QgsPalLayerSettings()
    settings.placement = QgsPalLayerSettings.Horizontal # Horizontal
    settings.fieldName = "picnum"
    text_format = QgsTextFormat()

    text_format.setFont(QFont("Arial", 12))
    #text_format.setSize(24)

    # get ranndomly assigned color from loading
    single_symbol_renderer = vlayer.renderer()
    symbol = single_symbol_renderer.symbol()
    symbol.setColor(color)
    text_format.setColor(color)
    settings.setFormat(text_format)

    pc = QgsPropertyCollection("dataDefinedProperties")
    # position the label à the end of the trajectory (source)
    prop=QgsProperty()
    prop.setField("X")
    prop.setExpressionString("x_at(-1)")
    pc.setProperty(9, prop)

    prop.setField("Y")
    prop.setExpressionString("y_at(-1)")
    pc.setProperty(10, prop)

    settings.setDataDefinedProperties(pc)

    settings.enabled = True
    root = QgsRuleBasedLabeling.Rule(QgsPalLayerSettings())
    rule = QgsRuleBasedLabeling.Rule(settings)
    rule.setDescription("label with picnum")
    root.appendChild(rule)
    vlayer.startEditing()
    vlayer.setLabelsEnabled(True)
    rules = QgsRuleBasedLabeling(root)
    vlayer.setLabeling(rules)
    vlayer.triggerRepaint()
    vlayer.commitChanges()

  def saveProject(self, project):
    project.write(os.path.join(data_dir,f"picnum_{self.getStation()}.qgs"))


def main():
  """ import bts with custom label color and position"""

  btsLoader = BtsLoad("/home/kwabena/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/karu/picnums")
  # btsLoader.loadShpFile(btsLoader.getProject(), btsLoader.getShpFilesPaths()[0], QColor("blue"))
  btsLoader.loadAllShpFiles(btsLoader.getProject(), btsLoader.getShpFilesPaths(), btsLoader.getColors(), btsLoader.getColorIdx())
  btsLoader.createMap(btsLoader.getProject())
  btsLoader.saveProject(btsLoader.getProject())

main()

if __name__ == '__main__':
  main()






