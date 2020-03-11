from PyQt5.QtGui import QColor

class BtsColors:
  colors = []
  colors.append(QColor("black"))
  colors.append(QColor("darkCyan"))
  colors.append(QColor("green")) 
  colors.append(QColor("darkGreen")) 
  colors.append(QColor("red"))
  colors.append(QColor("darkRed"))
  colors.append(QColor("blue"))
  colors.append(QColor("darkBlue"))
  colors.append(QColor("magenta"))
  colors.append(QColor("darkMagenta"))

  @staticmethod
  def initColors():
    pass


  @staticmethod
  def getColors():
    return BtsColors.colors
  