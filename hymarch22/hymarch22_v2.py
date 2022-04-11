#!/usr/bin/python3
# hymarch22 v2
# Karusphere
# Copyright March 2022
#
#

import os, sys
from sysconfig import get_path
from time import pthread_getcpuclockid
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
  QgsLayoutItemMap,
  QgsLayoutItemMapGrid,
  QgsLayoutObject,
  QgsLayoutPoint,
  QgsLayoutSize,
  QgsGraduatedSymbolRenderer,
  QgsMarkerLineSymbolLayer,
  QgsMarkerSymbol,
  QgsPrintLayout,
  QgsPropertyCollection,
  QgsProperty,
  QgsSimpleMarkerSymbolLayer,
  QgsSimpleMarkerSymbolLayerBase,
  QgsSingleSymbolRenderer,
  QgsMessageLog,
  QgsRectangle,
  QgsRendererCategory,
  QgsRendererRange,
  QgsSymbol,
  QgsUnitTypes,
  QgsVectorDataProvider,
  QgsVectorLayer,
  QgsVectorFileWriter,
  QgsWkbTypes,
  QgsSpatialIndex,
) 

from qgis.PyQt.QtGui import (
    QColor,
)

from config import Config
from pathlib import Path
from qgis.utils import iface

country_world_shp_file_path = Path("/home/kwabena/Documents/trafin/lovy/hymarch22/results/Countries_WGS84/Countries_WGS84.shp")

class Hymarch22:
  def __init__(self:'Hymarch22', scenario_name:'str'):
    self._path = Config.get_project_root() / 'results' / scenario_name
    self._project = QgsProject.instance()
    self._scenario_name = scenario_name
    self._Crs = 4326
    self.makePicture()
  
  def getNbShpFilesToLoad(self):
    return(self._nb_shp_files_to_load)

  def __initProject(self):
    self.loadShpFile(country_world_shp_file_path) 

  def createMap(self,project, layout_name):
    # get config per station
    #config = self.getGatesConfig(self.getStation()) 
    config = self.getDefaultScenarioConfig() 
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
    # [ self.addLabelToLayout(layout, gate, self.getConfigForLabels(self.getStation(), gate)) for gate in self.getGates()]

    # [ self.addStationShapeToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]

    # [ self.addStationShapeToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]

    # [ self.addStationLabelToLayout(layout, self.getConfigForStations(station)) for station in [self.getStation()]]
  
  def getDefaultScenarioConfig(self):
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
  
  def getCrs(self):
    return self._Crs
  
  def getPath(self):
    return(self._path)

  def getProject(self):
    return self._project

  def getShpFiles(self, path):
    shp_files = list(path.glob("*.shp"))
    return(shp_files)

  def getScenarioName(self):
    return(self._scenario_name)
  

  def configLayer(self, layer):
    line_symbol = QgsLineSymbol()
    # Create an marker line_symbol 
    marker_line = QgsMarkerLineSymbolLayer()
    marker_line.setInterval(5)

    # Configure the marker.
    simple_marker = QgsSimpleMarkerSymbolLayer()
    shape = QgsSimpleMarkerSymbolLayerBase.Line

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


  def loadShpFile(self, path):
    vlayer = QgsVectorLayer(path.as_posix(), path.name, "ogr")
    #vlayer = self.shpFileSetCrs(vlayer, self.getCrs())
    self.getProject().addMapLayer(vlayer)
    #vlayer.triggerRepaint()
    print(f"Layer {path.name} has been loaded!")

  def loadShpFile(self, path):
    vlayer = QgsVectorLayer(path.as_posix(), path.name, "ogr")
    vlayer = self.shpFileSetCrs(vlayer, self.getCrs())
    if not vlayer.isValid():
      print(f"Layer {path.name} failed to load!")
    else:
      self.getProject().addMapLayer(vlayer)
      #vlayer.triggerRepaint()
      print(f"Layer {path.name} has been loaded!")


  def loadAllShpFiles(self, project, shp_path):
    shp_files_path = self.getShpFiles(shp_path)
    for shp_file_path in shp_files_path:
      #self.loadShpFile(self.getProject(), shp_file_path, color=QColor('black'))
      self.loadShpFile(shp_file_path)
  
  def fixUnhandledLayersPath(self):
    for layer in self.getProject().mapLayers().values():
      name = layer.name()
      provider = layer.providerType()
      options = layer.dataProvider().ProviderOptions()
      new_path = self.getPath()
      new_url = new_path / f"{name}.shp"
      layer.setDataSource(new_url.as_posix(), name, provider, options)
      print(f"fixing layer {name} path")

  def makePicture(self):
    QgsApplication.setPrefixPath("/usr", True)
    qgs = QgsApplication([], False)

    qgs.initQgis()

    self.__initProject()
    self.createMap(self.getProject(), self.getScenarioName())

    # test to load one shp file, ok
    #path1 = list(self.getShpFiles(self.path))[0]
    #self.loadShpFiles()
    self.loadAllShpFiles(self.getProject(), self.getPath())

    self.saveProject()

    #path = self.getPath() /  f"{self.getPath().name}.qgs"
    #self.getProject().read(path.as_posix())

    #self.fixUnhandledLayersPath()

    #self.saveProject()

    qgs.exitQgis()
  
  def saveProject(self):
    path = self.getPath() /  f"{self.getPath().name}.qgs"
    print(f"path = {path}")
    self.getProject().write(path.as_posix())
  
  def shpFileSetCrs(self, vlayer, crs_value):
    crs = vlayer.crs()
    crs.createFromId(crs_value)
    vlayer.setCrs(crs)
    return vlayer


def main():
  scenario_number = str(input("which scenario ? (1: background air| 2: dust cases| 3: mixture)"))
  if scenario_number == '1':
    scenario_name = 'background_air'
  elif scenario_number == '2':
    scenario_name = 'dust_cases'
  elif scenario_number == '3':
    scenario_name = 'mixture'

  hy = Hymarch22(scenario_name=scenario_name)


if __name__ == "__main__":
  main()
