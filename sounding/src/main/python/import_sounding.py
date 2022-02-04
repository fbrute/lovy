# The import module 
import datetime 
from metpy.units import units
from siphon.simplewebservice.wyoming import WyomingUpperAir

#  Set the download window （ Here is UTC moment ）
start = datetime.datetime(1973, 1, 1, 12)
end = datetime.datetime(2020, 12, 31, 12)

datelist = []
while start<=end:
    datelist.append(start)
    start+=datetime.timedelta(hours=24)

#  Select the download site （ Take Beijing for example ）
stationlist = ['60018']

#  Bulk download 
for station in stationlist:
    for date in datelist:
        try:
            df = WyomingUpperAir.request_data(date, station)
            df.to_csv(station+'_'+date.strftime('%Y%m%d%H')+'.csv',index=False)
            print(f'{date.strftime("%Y%m%d_%H")} Download successful ')
        except Exception as e:
            print(f'{date.strftime("%Y%m%d_%H")} Download failed : {e}')
            pass