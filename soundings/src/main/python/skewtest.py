import numpy as np
import os.path

from skewt import SkewT

dir_path = os.path.abspath('/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundings/src/main/sql/tephi')
print(dir_path)
print(os.path.join(dir_path, 'test.txt'))

data = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float)
pressure = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=0)
temp = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=1)
mixr = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=2)
rh = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=3)
dwpt = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=4) 
height = np.loadtxt(os.path.join(dir_path, 'test.txt'), dtype=float, usecols=4) 
mydata=dict(zip(('pres','temp','mixr','relh','dwpt','hght'),(pressure,temp,mixr, rh, dwpt, height)))
S=SkewT.Sounding(soundingdata=mydata)
print(S)
S.plot_skewt(color='r')
