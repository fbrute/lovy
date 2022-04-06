from pathlib import Path, PosixPath

class Config:
  @staticmethod
  def get_met_root() -> PosixPath:
    return Path("/media/kwabena/MODIS/hysplit_data/retros_mars_2018")

  @staticmethod
  def get_res_root() -> PosixPath:
    return(Path("/media/kwabena/MODIS/hymarch22"))
  
  @staticmethod
  def get_project_root() -> PosixPath:
    return(Path("/home/kwabena/Documents/trafin/lovy/hymarch22"))

  @staticmethod
  def get_input_data_path() -> PosixPath:
    return(Path("/home/kwabena/Documents/trafin/lovy/hymarch22/input_data"))

  @staticmethod
  def get_scenarios_names():
    return(['background air', 'dust cases', 'mixture'])