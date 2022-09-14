# Synmaps
## To run the Synmaps (synthetic maps for bts):

1. alter the file below in the specified path with needed seeds (mean and std for gates)

```
path=/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/main/pyqgis/
file=pm10_sup_28_synth.py
```

2. copy the following lines inside a Qgis Python terminal :
```
sys.path.append("/home/kwabena/Documents/trafin/lovy/retros/src/retrostat/main/pyqgis")
import pm10_sup_28_synth
station = 'karu' # 'mada' | 'puer' | 'cuba'
pm10_sup_28_synth.main(station)
```