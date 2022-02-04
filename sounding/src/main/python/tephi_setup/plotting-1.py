import matplotlib.pyplot as plt
import os.path

import tephi

dew_point = os.path.join(tephi.DATA_DIR, 'dews.txt')
dew_data = tephi.loadtxt(dew_point, column_titles=('pressure', 'dewpoint'))
dews = zip(dew_data.pressure, dew_data.dewpoint)
tpg = tephi.Tephigram()
tpg.plot(dews)
plt.show()