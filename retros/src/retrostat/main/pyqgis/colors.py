from PyQt5.QtGui import QColor

class BtsColors:
  colors = {}
  colors['north'] = QColor("darkRed")
  colors['neap'] = QColor("darkBlue")
  colors['nwap'] = QColor("darkGreen")
  colors['sa'] = QColor("black")
  colors['swap'] = QColor("magenta")
  colors['black'] = QColor("black")

  @staticmethod
  def initColors():
    pass


  @staticmethod
  def getColors():
    return BtsColors.colors
  