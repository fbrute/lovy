#!/usr/bin/env python3
# Karusphere, copyright March 2022, July, August, September 2022
#
# A simulation is a placeholder for a bunch of scenarios.
#
# It is based on an excel file, for which each tab corresponds to
# a scenario which is an object based on a bunch of dates
# for which bts are generated or used

import datetime
from pathlib import Path, PosixPath
import tkinter as tk
from tkinter.simpledialog import askstring
import pandas as pd
import configfactory
import scenariofactory
from selectdialog import SelectDialog
from selectfiledialog import SelectFileDialog
import simulationtype
import sys


class Simulation():
    """
    A simulation is a placeholder for a bunch of scenarios.
    It is based on an excel file, for which each tab corresponds to
    a scenario which is an object based on a bunch of dates
    for which bts are generated or used

    Here we build a Simulation with a folder and a type (PROD or TEST)
     """

    def __init__(self, type=simulationtype.SimulationType.TEST):
        self.type = type
        root = tk.Tk()
        folder = askstring(
            parent=root,
            title="Simulation folder name",
            prompt="Which name would you like to give to your simulation?"
        )
        root.destroy()
        self.folder = self.format_folder(folder)
        print(self.folder)

        # selection du mode
        SelectDialog(['prod', 'test'])
        mode = SelectDialog.result
        # the config is based on the folder name
        if mode == 'prod':
            self.config = configfactory.make_config(simulationtype.SimulationType.PROD)
        elif mode == 'test':
            self.config = configfactory.make_config(simulationtype.SimulationType.TEST)
        else:
            sys.exit("This Config mode is not handled!")

        excel_file_path = Path("not_yet_a_file")
        while not excel_file_path.exists():
            excel_file_path = self.get_excel_file_path()

        self.excel_file_path = excel_file_path

        self.scenario_names = self.get_scenario_names(excel_file_path)

    @property
    def excel_file_path(self):
        return self._excel_file_path

    @excel_file_path.setter
    def excel_file_path(self, excel_file_path):
        self._excel_file_path = excel_file_path

    def format_folder(self, folder: str) -> str:
        """ Lowercase and replace spaces with underscores"""
        folder = folder.lower()
        folder = folder.replace(" ", "_")
        return folder

    def get_excel_file_path(self) -> Path:
        """ get a file thru a dialog window"""
        SelectFileDialog()
        return SelectFileDialog.result

    def get_scenario_names(self, excel_file: PosixPath) -> list:
        """ return the scenarios (tabs) dates in an excel file"""
        excel_dataframe = pd.read_excel(excel_file, sheet_name=None, dtype=datetime.date)
        return list(excel_dataframe.keys())

    @property
    def folder(self) -> str:
        return(self._folder)

    @folder.setter
    def folder(self, folder: str) -> None:
        try:
            if not folder or folder.isspace() or len(folder) == 0:
                raise SimulationError("folder name is empty!!")
            self._folder = self.format_folder(folder)
        except(SimulationError) as e:
            print(e).args

    def main(self):
        root = tk.Tk()
        folder = askstring(
            parent=root,
            title="Simulation folder name",
            prompt="Which name would you like to give to your simulation?"
        )
        root.destroy()
        self.folder = self.format_folder(folder)
        print(self.folder)

        excel_file_path = Path("not_yet_a_file")
        while not excel_file_path.exists():
            excel_file_path = self.get_excel_file_path()

        self.scenario_names = self.get_scenario_names(excel_file_path)

    def run_one_scenario(self):
        "run one scenario from a discovered list"

        # selection du nom du scenario
        SelectDialog(self.scenario_names)
        scenario_name = SelectDialog.result

        # selection du mode
        SelectDialog(['prod', 'test'])
        mode = SelectDialog.result

        # selection de l'action
        SelectDialog(['run', 'stat'])
        action = SelectDialog.result

        scenario = scenariofactory.make_scenario(
            name=scenario_name,
            mode=mode,
            action=action,
            excel_file_path=self.excel_file_path
        )

        scenario.get_bts()

    def run(self):
        for scenario_name in self.scenarios_names:
            scenario = scenariofactory.make_scenario(scenario_name, mode=self.mode)
            scenario.get_bts()

    @property
    def scenario_names(self):
        return self._scenario_names

    @scenario_names.setter
    def scenario_names(self, names):
        self._scenario_names = names

    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, type):
        self._type = type


class SimulationError(Exception):
    pass


class SimulationProd(Simulation):
    def __init__(self, type=simulationtype.SimulationType.PROD):
        super().__init__(type)


class SimulationTest(Simulation):
    def __init__(self, type=simulationtype.SimulationType.TEST):
        super().__init__(type)
