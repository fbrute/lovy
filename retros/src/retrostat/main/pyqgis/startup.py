# from qgis import *
# from qgis.core import QgsProject, QgsVectorLayer, QgsPalLayerSettings, QgsTextBufferSettings
# from qgis.core import QgsRuleBasedLabeling,QgsTextFormat,QgsField, QgsProperty, QgsPropertyCollection, QgsExpression
# from PyQt5.QtCore import QVariant
# import qgis.utils
import os, sys

# from qgis.utils import iface

# import PyQt5
# from PyQt5.QtGui import QFont, QColor

# #canvas = qgis.utils.iface.mapCanvas()
# # print(canvas.size())
sys.path.append("Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/main/pyqgis")
import picnum

# def main():
#   """ import bts with custom label color and position"""

#   shp_files = [x for x in os.listdir(data_dir) if x[-3:] =='shp']
#   vlayer = QgsVectorLayer(os.path.join(data_dir,shp_files[0]), "vect_1", "ogr")

#   project = QgsProject.instance()
                                
#   crs = vlayer.crs()
#   crs.createFromId(4326)
#   vlayer.setCrs(crs)

#   project.addMapLayer(vlayer, True)
#   vlayer = iface.activeLayer()
#   if vlayer.startEditing():
#     vlayer.addAttribute(QgsField("picnum", QVariant.Int))
#     if vlayer.changeAttributeValue(0,1,245):
#       print("ok changing attribute")
#       vlayer.updateFields()
#       vlayer.commitChanges()

#   vlayer = iface.activeLayer()
#   settings = QgsPalLayerSettings()
#   settings.placement = QgsPalLayerSettings.Curved # Horizontal
#   settings.fieldName = "picnum"
#   text_format = QgsTextFormat()

#   text_format.setFont(QFont("Arial", 12))
#   #text_format.setSize(24)

#   # get ranndomly assigned color from loading
#   single_symbol_renderer = vlayer.renderer()
#   symbol = single_symbol_renderer.symbol()
#   #text_format.setColor(QColor(0,255,0))
#   text_format.setColor(symbol.color())

#   #buffer_settings = QgsTextBufferSettings()
#   #buffer_settings.setEnabled(True)
#   #buffer_settings.setSize(42)
#   #buffer_settings.setColor(QColor(0,255,0))
#   settings.setFormat(text_format)
#   #text_format.setBuffer(buffer_settings)

#   pc = QgsPropertyCollection("dataDefinedProperties")

#   # position the label à the end of the trajectory (source)
#   prop=QgsProperty()
#   prop.setField("X")
#   prop.setExpressionString("x_at(-1)")
#   pc.setProperty(9, prop)

#   prop.setField("Y")
#   prop.setExpressionString("y_at(-1)")
#   pc.setProperty(10, prop)

#   settings.setDataDefinedProperties(pc)

#   settings.enabled = True
#   root = QgsRuleBasedLabeling.Rule(QgsPalLayerSettings())
#   rule = QgsRuleBasedLabeling.Rule(settings)
#   rule.setDescription("label with picnum")
#   #rule.setColor(QColor(0,255,0))
#   #rule.setFont((QFont("Arial", 24))
#   root.appendChild(rule)

#   #vlayer = iface.activeLayer()
#   #vlayer.startEditing()

#   #vlayer.dataProvider().addAttributes([QgsField("picnum", QVariant.Int)])


#   vlayer.startEditing()
#   vlayer.setLabelsEnabled(True)
#   rules = QgsRuleBasedLabeling(root)
#   vlayer.setLabeling(rules)
#   vlayer.triggerRepaint()
#   vlayer.commitChanges()

#   # other method
#   # labeling = iface.activeLayer().labeling().clone()
#   # settings = labeling.settings()
#   # settings.placement = 0
#   # format.setFont(QFont("Arial", 24))
#   # format = settings.format()
#   # format.setSize(42)
#   # format.setColor(QColor(0,255,0))
#   # format.setSizeUnit(QgsUnitTypes.RenderPoints)
#   # settings.setFormat(format)
#   # labeling.setSettings(settings)
#   # iface.activeLayer().setLabeling(labeling)

#   #project.addMapLayer(vlayer, False)

#   project.write(os.path.join(data_dir,'retro_add.qgs'))


# if __name__ == '__main__':
#   main()





