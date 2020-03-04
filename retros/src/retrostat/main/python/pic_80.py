# !/usr/bin/env /Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/3.7/bin/python3.7
import sys
sys.path.append("/Applications/QGIS3.10.app/Contents/Resources/python")
sys.path.append("/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python")
sys.path.append('/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python/plugins')
sys.path.append('/Applications/QGIS3.10.app/Contents/Resources/python/plugins')
# sys.path.append('/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7/site-packages')
# sys.path.append('/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python37.zip')
# sys.path.append('/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7/site-packages/geos')
# sys.path.append('/Applications/QGIS3.4.app/Contents/Resources/python')
sys.path.append('/Applications/QGIS3.10.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7/lib-dynload')
# sys.path.append('/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7')
# sys.path.append('/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python')
# sys.path.append('/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/retros_path')

print(sys.path)

# sys.path.append("/Applications/QGIS3.4.app/Contents/Resources/python")
# sys.path.append(
#     "/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python")
# sys.path.append(
#    "/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python/plugins")
# sys.path.append(
#     "/Applications/QGIS3.4.app/Contents/MacOS/../Resources/python/plugins")
# sys.path.append("/Applications/QGIS3.4.app/Contents/PlugIns/platforms")
# sys.path.append(
#     "/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7/site-packages")
# sys.path.append(
#     "/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python3.7/lib-dynload")
# sys.path.append(
#    "/Users/france-norbrute/Library/Application Support/QGIS/QGIS3/profiles/default/python")
# sys.path.append(
#    "/Applications/QGIS3.4.app/Content/MacOs/../Resources/python/plugins")

# sys.path.append(
#    "/Applications/QGIS3.4.app/Contents/PlugIns/platforms/libqcocoa.dylib")

# sys.path.append('/Applications/QGis.app/Contents/Resources/python/plugins')

from qgis.core import *
import qgis.utils
from PyQt5 import *

# Supply path to qgis install location
QgsApplication.setPrefixPath(
    "/Applications/QGIS3.10.app/Contents/MacOs", True)
print("3######################################################")
# Create a reference to the QgsApplication. Setting the
# second argument to False disables the GUI.
qgs = QgsApplication([], False)
print("4######################################################")
# Load providers
qgs.initQgis()
print("5######################################################")
# Write your code here to load some layers, use processing
# algorithms, etc.
# Finally, exitQgis() is called to remove the
# provider and layer registries from memory
qgs.exitQgis()

layer_settings  = QgsPalLayerSettings()
text_format = QgsTextFormat()
background_color = QgsTextBackgroundSettings()

background_color.setFillColor(QColor('white'))
background_color.setEnabled(True)

text_format.setFont(QFont("Arial", 12))
text_format.setSize(24)
text_format.setBackground(background_color )

buffer_settings = QgsTextBufferSettings()
buffer_settings.setEnabled(True)
buffer_settings.setSize(0.10)
buffer_settings.setColor(QColor("black"))

text_format.setBuffer(buffer_settings)
layer_settings.setFormat(text_format)

layer_settings.fieldName = "Label"
layer_settings.placement = 4

layer_settings.enabled = True

layer_settings = QgsVectorLayerSimpleLabeling(layer_settings)
layer.setLabelsEnabled(True)
layer.setLabeling(layer_settings)
layer.triggerRepaint()