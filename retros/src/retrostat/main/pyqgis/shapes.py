from qgis.core import QgsSimpleMarkerSymbolLayerBase

class BtsShapes:
  shapes = {}
  shapes['north'] = QgsSimpleMarkerSymbolLayerBase.Circle
  shapes['neap'] =  QgsSimpleMarkerSymbolLayerBase.Diamond
  shapes['nwap'] =  QgsSimpleMarkerSymbolLayerBase.Triangle
  shapes['sa']   =  QgsSimpleMarkerSymbolLayerBase.Star
  shapes['swap'] =  QgsSimpleMarkerSymbolLayerBase.ArrowHeadFilled

  colors = {}
  colors['north'] = "darkRed"
  colors['neap'] = "darkGreen"
  colors['nwap'] = "red"
  colors['sa'] = "black"
  colors['swap'] = "darkBlue"
  colors['black'] = "black"

  @staticmethod
  def initShapes():
    pass


  @staticmethod
  def getShapes():
    return BtsShapes.shapes

  @staticmethod
  def getColors():
    return BtsShapes.colors
  