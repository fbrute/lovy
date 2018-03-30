#!/usr/bin/env python
import numpy as np
import numpy.ma as ma
import os.path
from matplotlib.pyplot import rcParams,figure,show,draw
import sys

dir_path = "/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/soundings/src/main/sql/tephi"
print(dir_path)

from skewt import SkewT

files = [
        os.path.join(dir_path, 'guadeloupe_jnp_mjja_tephi_data_inf_28.txt'),
        os.path.join(dir_path, 'guadeloupe_mjja_faible_tephi_data.txt'),
        os.path.join(dir_path, 'guadeloupe_mjja_moyen_tephi_data.txt'),
        os.path.join(dir_path, 'guadeloupe_mjja_fort_tephi_data.txt'),

        os.path.join(dir_path, 'puerto_rico_jnp_mjja_tephi_data_inf_28.txt'),
        os.path.join(dir_path, 'puerto_rico_mjja_faible_tephi_data.txt'),
        os.path.join(dir_path, 'puerto_rico_mjja_moyen_tephi_data.txt'),
        os.path.join(dir_path, 'puerto_rico_mjja_fort_tephi_data.txt')
        ]




def get_data(file):
    pres, temp, mixr, relh, dwpt, hght , sknt, drct = np.loadtxt(file, usecols=range(0, 8), unpack=True)

    okmask = [0]*len(pres)

    temp = ma.masked_array(temp, mask = okmask, fill_value = -999.0)
    mixr = ma.masked_array(mixr, mask = okmask, fill_value = -999.0)
    dwpt = ma.masked_array(dwpt, mask = okmask, fill_value = -999.0)
    hght = ma.masked_array(hght, mask = okmask, fill_value = -999.0)
    sknt = ma.masked_array(sknt, mask = okmask, fill_value = -999.0)
    drct = ma.masked_array(drct, mask = okmask, fill_value = -999.0)
    pres = ma.masked_array(pres, mask = okmask, fill_value = -999.0)

    data=dict(zip(('hght' , 'pres','temp','dwpt','mixr','relh','sknt','drct'),( hght, pres, temp, dwpt, mixr, relh, sknt, drct)))
    return data

mydatas = [get_data(files[0]),
           get_data(files[1]),
           get_data(files[2]),
           get_data(files[3]),
           get_data(files[4]),
           get_data(files[5]),
           get_data(files[6]),
           get_data(files[7])
]


S=SkewT.Sounding(soundingdata=mydatas[0])
T=SkewT.Sounding(soundingdata=mydatas[1])
U=SkewT.Sounding(soundingdata=mydatas[2])
V=SkewT.Sounding(soundingdata=mydatas[3])
W=SkewT.Sounding(soundingdata=mydatas[4])
X=SkewT.Sounding(soundingdata=mydatas[5])
Y=SkewT.Sounding(soundingdata=mydatas[6])
Z=SkewT.Sounding(soundingdata=mydatas[7])

S.make_skewt_axes()
S.add_profile(color='r',bloc=1, linestyle = '--')

S.soundingdata = T.soundingdata
S.add_profile(color='gold',bloc=2)

S.soundingdata = U.soundingdata
S.add_profile(color='orange', bloc=3)

S.soundingdata = V.soundingdata
S.add_profile(color='red',bloc=4)

S.soundingdata = W.soundingdata
S.add_profile(color='blue',bloc=5, linestyle = '--')

S.soundingdata = X.soundingdata
S.add_profile(color='cyan',bloc=6)

S.soundingdata = Y.soundingdata
S.add_profile(color='dodgerblue',bloc=7)

S.soundingdata = Z.soundingdata
S.add_profile(color='darkblue',bloc=8)

show()
