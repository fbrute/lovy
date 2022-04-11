#!/usr/bin/python3
# hymarch22 v2
# Karusphere
# Copyright March 2022
#
from PyQt5.QtWidgets import QApplication

from qgis.core import ( 
  QgsProject, 
  QgsApplication, 
  QgsPathResolver
)

from qgis.gui import (
  QgsMapCanvas,
  QgsLayerTreeMapCanvasBridge
) 

from config import Config

def fixUnhandledLayersPath(project):
  for layer in print.mapLayers().values():
    name = layer.name()
    provider = layer.providerType()
    options = layer.dataProvider().ProviderOptions()
    new_path = self.getPath()
    new_url = new_path / f"{name}.shp"
    layer.setDataSource(new_url.as_posix(), name, provider, options)
    print(f"fixing layer {name} path")

def my_processor(path):
  return(path.replace('./', shp_path))

def main():
  scenario_number = str(input("which scenario ? (1: background air| 2: dust cases| 3: mixture)"))
  if scenario_number == '1':
    scenario_name = 'background_air'
  elif scenario_number == '2':
    scenario_name = 'dust_cases'
  elif scenario_number == '3':
    scenario_name = 'mixture'

  #app = QApplication([]) 
  qgs = QgsApplication.setPrefixPath("/usr", True)

  qgs = QgsApplication([], False)
  qgs.initQgis()

  canvas = QgsMapCanvas()
  project = QgsProject.instance()
  # syncro
  #bridge = QgsLayerTreeMapCanvasBridge( project.layerTreeRoot(), canvas)

  path_to_project = Config.get_project_root()
  path_to_shp_files = Config.get_project_root() / 'results' / scenario_name
  project_name = path_to_shp_files / f"{scenario_name}.qgs"

  QgsPathResolver.setPathPreprocessor(my_processor)

  project.read(project_name.as_posix())

  print(project.fileName())

  #project.write(project_name.as_posix())

  canvas.show()

  app.exec_

  qgs.exitQgis()


if __name__ == "__main__":
  main()