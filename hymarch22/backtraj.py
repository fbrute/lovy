from config import Config
from datetime import date
import subprocess

class Backtraj:
  """ Get the files for a station and a date"""
  def __init__(self, station, bts_date, level=1500, mode='prod', date_format='dmy'):
    """ date should be mdy with / separeted (7/11/2009) """
    self.station = station
    self.bts_date = self.dmy_to_ymd(bts_date)
    self.level = str(level)
    self.mode = mode
    self.date_format = date_format
    self.set_path()
  
  def get_ymd_date_string_from_date(self:'Backtraj', date:'date')-> str:
    return(date.strftime("%y%m%d"))

  def set_path(self) -> None:
    self.path = Config.get_met_root() / f"{self.station}_{self.level}" / f"{self.bts_date.year}"

  def dmy_to_ymd(self:'Backtraj', bts_date:'str') -> date:
    """ date is dmy formatted (01/04/2007), so we convert to ymd """
    print("bts_date=", bts_date)
    nday = int(bts_date[0:2])
    nmonth = int(bts_date[3:5])
    nyear = int(bts_date[6:10])
    return date(nyear, nmonth, nday)

  def exists(self)-> bool:
    ymd = self.bts_date.strftime("%y%m%d")
    search = f"*gis_shape{ymd}*"
    files=list(self.path.glob(search))
    print(files)
    return(len(files) >= 4)

  def get_files(self):
    ymd = self.bts_date.strftime("%y%m%d")
    search = f"*{ymd}*"
    files=list(self.path.glob(search))
    return(files)

  def generate(self):
    """ Generate the bt if necessary"""
    if not self.exists():
      subprocess.run([ Config.get_project_root() / "one_day_traj.sh", 
      self.station, self.level, self.date_format, self.get_ymd_date_string_from_date(self.bts_date) , self.mode])