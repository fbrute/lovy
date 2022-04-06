#!/usr/bin/env python3
from asyncio import subprocess
from matplotlib.pyplot import bar
from backtraj import Backtraj
from config import Config
from pathlib import Path
from datetime import date
import functools, operator
import shutil
import sys
import pandas as pd
import datetime
import re

class Scenario:
  def __init__(self,name, mode):
    self.name = name
    self.input_data_path = Config.get_input_data_path() / 'tests' / 'scenarios' / name
    if mode == 'test':
      self.path = Config.get_res_root() / 'tests' / 'scenarios' / name
      self.result_path = Config.get_res_root() /  'tests' / 'results' / name
    elif mode == 'prod':
      self.path = Config.get_res_root() / 'scenarios' / name
      self.result_path = Config.get_res_root() /  'results' / name
    else:
      sys.exit()

    #self.path = Config.getResRoot() / 'scenarios' / name
    self.files = list(self.path.glob('*.txt'))
    self.mode = mode

  def get_files(self) :
    return(self.files) 

  def get_name(self):
    return(self.name)
  
  def file_is_gis_related(self:'Scenario',filepath:'str') -> bool:
    if filepath[-3:] in ['shp','shx','dbf','prj']:
      return True

  def file_is_shp_related(self:'Scenario', filename:'str') -> bool:
    found_or_not = filename.find('.shp')
    return(found_or_not >= 0)
  
  def get_bts(self):
    self.number_of_times_not_found_in_bts_dates = {} 
    self.number_of_times_already_found_in_results = {} 
    for file in self.files:
      station = self.get_station(file)
      dates = self.get_dates(file)
      for date in dates:
        bt = Backtraj(station=station, bts_date=date, mode = self.mode, date_format='dmy')
        if not bt.exists():
          print("######################### generating missing bt ###################")
          bt.generate()
          if not bt.exists():
            print(f"date ({date}) not found in bts folder!")
            key = f"{station}_{date}"
            if not (key in self.number_of_times_not_found_in_bts_dates.keys()):
              self.number_of_times_not_found_in_bts_dates[key] = 1 
            else:
              self.number_of_times_not_found_in_bts_dates[key] += 1
            continue
        bts_files = bt.get_files()
 
        for bts_file in bts_files:
          # copy only gis related files
          if not self.file_is_gis_related(bts_file.name):
            continue
          source = bts_file
          print(f"source = {source}")
          target = self.result_path / f"{station}_{bts_file.name}" 
          print(f"target = {target}")

          if (not target.is_file()):
            shutil.copy(source, target )
            print(f"{target} has been copied")
          else:
            print(f"target ({target}) not copied, already present in results folder!")
            if self.file_is_shp_related(source.name):
              key = f"{station}_{date}_{source.name}"
              if not (key in self.number_of_times_already_found_in_results.keys()):
                self.number_of_times_already_found_in_results[key] = 1
              else:
                self.number_of_times_already_found_in_results[key] += 1

    print(f"number_of_dates_already_found_in_results={self.number_of_times_already_found_in_results}")
    #print(f"dates_not_found_in_bts_dates={self.number_of_times_not_found_in_bts_dates}")
    print("###############################################################################")
    print(f"dates_not_found_in_bts_dates={self.number_of_times_not_found_in_bts_dates}")
    print("###############################################################################")
    print(f"number_of_dates_already_found_in_results={len(self.number_of_times_already_found_in_results)}")
    print(f"number_of_dates_not_found_in_bts_dates={len(self.number_of_times_not_found_in_bts_dates)}")

    #bar_dates = [ bts_station_date for bts_station_date in self.number_of_times_not_found_in_bts_dates.keys() if bts_station_date.find('barb')]
    bar_dates = [key[5:] for key in self.number_of_times_not_found_in_bts_dates.keys() if key.find('barb')>=0]
    if len(bar_dates) > 0:
      print(f"number of barb dates) = {len(bar_dates)}")
      print(f"bar_dates = {bar_dates}")

    return(True)
  
  def get_station(self, file):
    return(file.name[:4])

  def get_dates(self, file):
    """ Get dates for a file belonging to a scenario """
    dates_file= open(file)
    datesList = dates_file.readlines()
    stringOfDates = functools.reduce(operator.concat, [line.rstrip()+' ' for line in datesList])
    dates_file.close()
    return(stringOfDates.split())
  
  def get_dates_v2(self,name):
    """ Get dates for a file belonging to a scenario """
    df = pd.read_excel(self.input_data_path / 'hysplit_days_v3.xlsx', sheet_name= name, dtype=datetime.date)
    # each column is related to a station
    #self.df_dates = 

  def get_nb_dates(self, string_of_dates):
    """ Get the number of dates in a scenario date file """
    dates = string_of_dates
    return(dates)

  def get_unique_dates(self, file):
    return(set(self.get_dates(file)))
  
  def stat(self, file):
    print("Number of unique dates in scenario")
    return(len(self.get_unique_dates(file)))
  


if __name__ == "__main__":
  mode=str(input("which mode ? (test|prod)"))
  action=str(input("which action ? (run|stat)"))
  scenario_number = str(input("which scenario ? (1: background air| 2: dust cases| 3: mixture)"))
  if scenario_number == '1':
    scenario_name = 'background_air'
  elif scenario_number == '2':
    scenario_name = 'dust_cases'
  elif scenario_number == '3':
    scenario_name = 'mixture'

  if action == 'run':
    sc = Scenario(scenario_name, mode) 
    sc.get_bts()
  if action == 'stat':
    sc = Scenario(scenario_name, mode) 
    sc.stat()