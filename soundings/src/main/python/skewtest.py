import numpy as np
import os.path

from skewt import SkewT

dir_path = os.path.abspath('/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundings/src/main/sql/tephi')
print(dir_path)

file =os.path.join(dir_path, 'skewt_data.txt')

S=SkewT.Sounding(file)
print(S)
S.plot_skewt(color='r')
