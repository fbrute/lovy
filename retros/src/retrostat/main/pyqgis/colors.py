from PyQt5.QtGui import QColor

class BtsColors:
  colors = {}
  colors['north'] = QColor("darkRed")
  colors['neap'] = QColor("darkGreen")
  colors['nwap'] = QColor("red")
  colors['sa'] = QColor("black")
  colors['swap'] = QColor("darkBlue")
  colors['black'] = QColor("black")

  @staticmethod
  def initColors():
    pass


  @staticmethod
  def getColors():
    return BtsColors.colors
  