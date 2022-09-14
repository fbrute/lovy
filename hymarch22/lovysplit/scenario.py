#!/usr/bin/env python3

# Scenario corresponds to a sheet in an excel file
# A scenario may contain several columns
# each column contains dates (usually mdy)

# The main function asks for an excel file, and can
# read the different scenarios (tabs) available
# A tab is named after a station, so please ascertain wether the
# station name is normalized ( barb | cuba | mada | karu | puer)

# This version can't handle multiple columns for a tab
# Check the previous version (mars 2022) from git if necessary

from config import Config
import datetime
from enum import Enum
import pandas as pd
from selectdialog import SelectDialog
import shutil
import sys
import utils


class ConfigAction(Enum):
    """ Enum for config actions """
    RUN = 1
    STAT = 2

    def __repr__(self):
        return self.name.lower()

    def __str__(self):
        return self.name.lower()


class ScenarioError(Exception):
    pass


class Scenario:
    def __init__(self, name, mode, excel_file_path):
        self.name = name
        self.excel_file_path = excel_file_path
        self.config = Config()
        if mode == 'test':
            self.path = Config.get_res_root() / 'tests' / 'scenarios' / name
            self.result_path = Config.get_res_root() / 'tests' / 'results' / name
        elif mode == 'prod':
            self.path = Config.get_res_root() / 'scenarios' / name
            self.result_path = Config.get_res_root() / 'results' / name
        else:
            sys.exit()
        self.mode = mode
        self.excel_file_path = excel_file_path
        self.set_dates()

    def file_is_gis_related(self: 'Scenario', filepath: 'str') -> bool:
        if filepath[-3:] in ['shp', 'shx', 'dbf', 'prj']:
            return True

    def file_is_shp_related(self: 'Scenario', filename: 'str') -> bool:
        found_or_not = filename.find('.shp')
        return(found_or_not >= 0)

    def make_target_filename(self, bts_file_name):
        return self.result_path / f"{self.station}_{bts_file_name}"

    def generate_bts(self):
        for date in self.get_dates():
            bt = Backtraj(station=self.station, bts_date=date, mode=self.mode, date_format='dmy')
            bt.generate()
            bt.move(self.result_path)

    def copy_bts(self):
        for source in self.get_files():
            source = bts_file
            print(f"source = {source}")
            target = self.result_path / f"{self.station}_{bts_file.name}"
            print(f"target = {target}")

            if (not target.is_file()):
                shutil.copy(source, target)
                print(f"{target} has been copied")
            else:
                print(f"target ({target}) not copied, already present in results folder!")
                if self.file_is_shp_related(source.name):
                    key = f"{self.station}_{date}_{source.name}"
                    if not (key in self.n_already_found_in_results.keys()):
                        self.n_already_found_in_results[key] = 1
                    else:
                        self.n_already_found_in_results[key] += 1
        return(True)

    def get_files(self):
        return(self.files)

    def get_name(self):
        return(self.name)

    def get_dates(self):
        return(set(self.dates))

    def get_station(self):
        return(self.station)

    def set_station(self):
        station = self.name[:4]
        if utils.isstation(station):
            return(station)
        else:
            print("************************************************************")
            print("station name not found! ... scenario aborted!!!")
            print("************************************************************")
            sys.exit()

    def get_nb_dates(self):
        """ Get the number of dates in a scenario date file """
        return len(self.dates)

    def get_unique_dates(self):
        return(set(self.get_dates()))

    def set_dates(self):
        """ Get dates for a file belonging to a scenario """
        self.dates = pd.read_excel(self.excel_file_path, sheet_name=self.name, dtype=datetime.date)
        # each column is related to a station (initial version)

    def stat(self, file) -> int:
        print("Number of unique dates in scenario")
        return(len(self.get_unique_dates(file)))


def main():

    # select the input data excel file
    excel_file_path = Path("not_yet_a_file")
    while not excel_file_path.exists():
        excel_file_path = self.get_excel_file_path()

    scenario_names = self.get_scenario_names(excel_file_path)

    # selection du nom du scenario
    SelectDialog(scenario_names)
    scenario_name = SelectDialog.result

    # selection du mode
    SelectDialog(['prod', 'test'])
    mode = SelectDialog.result

    # selection de l'action
    SelectDialog(['run', 'stat'])
    action = SelectDialog.result

    self.config = Config()
    sc = Scenario(scenario_name, mode, excel_file_path=excel_file_path)
    print(sc.get_nb_dates())

    if action == 'run':
        sc = Scenario(scenario_name, mode, excel_file_path)
        print(sc.get_nb_dates())
        sys.exit()
        sc.get_bts()
    if action == 'stat':
        sys.exit()
        sc.generate_bts()
        sc = Scenario(scenario_name, mode)
        sc.stat()


