class Gate:
  def __init__(self, name, north, east, south, west):
    self.name = name
    self.north = north
    self.east = east
    self.south = south
    self.west = west

  def height(self):
    return abs(self.north - self.south)
  
  def width(self):
    return abs(self.east - self.west)


Gates = [] 
Gates.append(Gate("NWAP",  35, -16,  10, -20))
Gates.append(Gate("SWAP",  10, -16,   0, -20))
Gates.append(Gate("NEAP",  35, -20,  20, -50))
Gates.append(Gate("SA",    10, -30,   0, -50))
Gates.append(Gate("NORTH", 30,  -50, 20, -60))
