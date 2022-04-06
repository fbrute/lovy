# project.py
# contains Project class,base of Hymarch22 project

from pathlib import Path, PosixPath
import os

class Project:
  def __init__(self, name):
    self.METROOT= Path("/media/kwabena/MODIS/hysplit_data")
    self.RESROOT= Path("/media/kwabena/MODIS/hymarch22")
    self.PROJECTROOT= Path("/home/kwabena/Documents/trafin/lovy/hymarch22")
    self.scenarios = ['background_air', 'dust_cases', 'mixture']
    self.name = name 
    self.scenarios_paths =  [ 
      self.RESROOT / 'scenarios' / self.scenarios[0],
      self.RESROOT / 'scenarios' / self.scenarios[1],
      self.RESROOT / 'scenarios' / self.scenarios[2] 
    ]
    self.retrieve_bts()

  def check_data_folder(self):
    """ check the hierarchy of folders is ok"""
    folders = [folder for folder in self.METROOT.iterdir() if folder.is_dir()]
    if Path(f"{self.METROOT}/2007") in folders and Path(f"{self.METROOT}/2016") in folders:
     return(True)
    #print(folders)
    # Check that the folder with BTS is accessible 
    #year_folders = [ Path(f"{self.METROOT}/{year}") for year in range(2006,2017)]
    #result = all(elem in folders for elem in year_folders)
    #print(f"result={result}")
    #print(year_folders)

  def check_project_root_folder(self):
    """ Check the existence of root folder (also app folder) """
    return(self.PROJECTROOT.is_dir())

  def check_result_folders(self):
    """ Check that the results folder contains the proper hierarchy """
    if not (self.RESROOT.is_dir()):
      return(False)
    if not (self.RESROOT / 'scenarios'):
      return(False)
    if not (self.RESROOT / 'scenarios' / 'background_air'):
      return(False)
    if not (self.RESROOT / 'scenarios' / 'dust_cases'):
      return(False)
    if not (self.RESROOT / 'scenarios' / 'mixture'):
      return(False)
    if not (self.RESROOT / 'results'):
      return(False)
    if not (self.RESROOT / 'results' / 'background_air'):
      return(False)
    if not (self.RESROOT / 'results' / 'dust_cases'):
      return(False)
    if not (self.RESROOT / 'results' / 'mixture'):
      return(False)
    
    return(True)

  def prepare_results_folders(self):
    """ prepare hierarchy of folders"""
    for path in self.scenario_paths:
      if not path.is_dir():
        print(path)
        path.mkdir(parents=True)
    
    return(True)
  
  def get_retro_files_for_scenario(self,scenario):
    pass
  
  def get_retro_files(self, date):
    """ Get the bts files from dates that are expected to be ymd """
    pass

  def retrieve_bts(self):
    for scenario_folder in self.scenarios_paths:
      print(scenario_folder)
      scenario_files = list(scenario_folder.glob('*.txt'))
      print(scenario_files)

  def retrieve_scenario_files_for_a_scenario(self, scenario_folder):
      scenario_files = list(scenario_folder.glob('*.txt'))



if __name__ ==  "__main__":
  hymarch22 = Project("Hymarch22")