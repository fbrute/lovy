from qgis import *
from qgis.core import QgsProject, QgsVectorLayer, QgsPalLayerSettings, QgsTextBufferSettings
from qgis.core import QgsRuleBasedLabeling,QgsTextFormat,QgsField, QgsProperty, QgsPropertyCollection, QgsExpression
from PyQt5.QtCore import QVariant
import qgis.utils
import os, sys, re

from qgis.utils import iface

import PyQt5
from PyQt5.QtGui import QFont, QColor

data_dir = '/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/puer/picnums'
country_world_shp_file_path = "/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/retros_path/Countries_WGS84/Countries_WGS84.shp"
#canvas = qgis.utils.iface.mapCanvas()
# print(canvas.size())
sys.path.append("Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/main/pyqgis")

class BtsLoad:
  def __init__(self, data_dir):
    """ build BtsLoad with a path directory """
    self.__initBts(data_dir)
  
  def __initBts(self, data_dir):
    self.setBtsPathDir(data_dir)
    shp_files_paths = self.__retrieveShpFilesPaths(data_dir)
    if (len(shp_files_paths) < 1): 
      raise AssertionError("No shape files in the path directory provided.")
    self.setShpFilesPaths(shp_files_paths)
    project = QgsProject.instance()
    self.setCrs(4326)
    self.__initProject(project)

  def setCrs(self,crs_id):
    self.crs = crs_id

  def getCrs(self):
    return self.crs

  def __initProject(self, project):
    self.setProject(project)
    self.loadShpFile(self.getProject(), country_world_shp_file_path) 
    vlayer = iface.activeLayer()
    self.setVectorLayorColorToValue(vlayer, 0)
    self.setVectorLayerOpacityToValue(vlayer, 0.3)
    return self.getProject()

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
  
  def loadAllShpFiles(self, project, shp_files_paths):
    [self.loadShpFile(self.getProject(), shp_file_path) for shp_file_path in shp_files_paths]
  
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
  
  def shpFileSetCrs(self, vlayer, crs_value):
    crs = vlayer.crs()
    crs.createFromId(crs_value)
    vlayer.setCrs(crs)
    return vlayer

  def loadShpFile(self, project, shp_file_path):
    vlayer = self.getLayerFromPath(os.path.join(self.getBtsPathDir(), shp_file_path))
    vlayer = self.shpFileSetCrs(vlayer, self.getCrs())
    # crs = vlayer.crs()
    # crs.createFromId(4326)
    # vlayer.setCrs(crs)

    project.addMapLayer(vlayer, True)

    vlayer = iface.activeLayer()
    if vlayer.startEditing():
      vlayer.addAttribute(QgsField("picnum", QVariant.Int))
      if vlayer.changeAttributeValue(0,1,int(self.getPicnum(shp_file_path))):
        print("ok changing attribute")
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
    #text_format.setColor(QColor(0,255,0))
    text_format.setColor(symbol.color())
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
    #rule.setColor(QColor(0,255,0))
    #rule.setFont((QFont("Arial", 24))
    root.appendChild(rule)
    vlayer.startEditing()
    vlayer.setLabelsEnabled(True)
    rules = QgsRuleBasedLabeling(root)
    vlayer.setLabeling(rules)
    vlayer.triggerRepaint()
    vlayer.commitChanges()

  def saveProject(self, project):
    project.write(os.path.join(data_dir,'retro_add.qgs'))


def main():
  """ import bts with custom label color and position"""

  btsLoader = BtsLoad("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/puer/picnums")
  #btsLoader.loadShpFile(btsLoader.getProject(), btsLoader.getShpFilesPaths()[0])
  btsLoader.loadAllShpFiles(btsLoader.getProject(), btsLoader.getShpFilesPaths())
  btsLoader.saveProject(btsLoader.getProject())

main()

if __name__ == '__main__':
  main()






