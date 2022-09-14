# BackTraj object to represent and handle a hysplit backtraj
#

from config import Config
from datetime import date
from enum import Enum
import os.path
from pathlib import Path
import shutil
import simulation
import subprocess
from utils import Station


class BackTrajMode(Enum):
    """ Choose the expected behaviour with bts """
    RUN = 1
    STAT = 2

    def __repr__(self):
        return str(self.name).lower()

    def __str__(self):
        return str(self.name).lower()


class BackTrajLevel(Enum):
    """ Hysplit Level """
    LEVEL1500 = 1500
    LEVEL2000 = 2000

    def __repr__(self):
        return str(self.value)

    def __str__(self):
        return str(self.value)


class BackTraj:
    """ Get the files for a station and a date"""
    def __init__(
        self,
        config: Config,
        station: Station,
        bts_date: date,
        level=BackTrajLevel.LEVEL1500,
        mode=simulation.SimulationType.TEST,
    ):
        self.config = config
        self.station = station
        self.bts_date = bts_date
        self.level = str(level)
        self.mode = mode
        self._path = self.make_path()

        ymd = self.bts_date.strftime("%y%m%d")
        self._search_pattern = f"*{ymd}*"
        self._files = list(self.path.glob(self._search_pattern))

    @staticmethod
    def get_ymd_date_string_from_date(date: 'date') -> str:
        """ Ensure the hysplit model receive a yymmdd date """
        return(date.strftime("%y%m%d"))

    def dmy_to_ymd(self, bts_date: 'str') -> date:
        """ date is dmy formatted (01/04/2007), so we convert to ymd """
        print("bts_date=", bts_date)
        nday = int(bts_date[0:2])
        nmonth = int(bts_date[3:5])
        nyear = int(bts_date[6:10])
        return date(nyear, nmonth, nday)

    def remove_files(self) -> bool:
        """ Remove all the files related to the bts """
        [file.unlink() for file in self.path.iterdir() if self.path.is_dir() and file.is_file()]

    def exists(self) -> bool:
        return(len(self.files) >= 4)

    @property
    def files(self):
        return(self._files)

    @files.setter
    def files(self, files):
        self._files = files

    def generate(self):
        """ Generate the bt if necessary"""
        if not self.exists():
            subprocess.run([
                Config.get_project_root() / "one_day_traj.sh",
                Config.get_project_root(),
                str(self.station),
                str(self.level),
                # ensure date is yymmdd for hysplit generator
                self.get_ymd_date_string_from_date(self.bts_date),
                str(self.mode)])
            self._files = list(self.path.glob(self._search_pattern))

    @staticmethod
    def is_valid_date(date_to_check: date):
        try:
            if date_to_check.year not in range(2006, 2017):
                raise ValueError("Date is not valid. Year should be between 2006 and 2016")
            else:
                return True

        except ValueError:
            print("Date is not valid. Year should be between 2006 and 2016")
            return False

    @staticmethod
    def is_valid_level(self, level):
        names = set([member.name for member in BackTrajLevel])
        if level.name not in names:
            raise AttributeError(f"this level({level}) is not handled!")

    def make_path(self) -> Path:
        path = Path(
            os.path.join(
                str(self.config.get_met_root_path()),
                f"{self.station}_{self.level}",
                f"{self.bts_date.year}"
            )
        )

        if not path.exists() and path.is_dir():
            path.mkdir()

        return path

    def move(self, target_folder) -> bool:
        try:
            for file in self.get_files():
                shutil.move(file, Path(target_folder))
        except OSError as e:
            print(f"Error while moving bts files to target_folder:\
            {target_folder} with error {e}")

    @property
    def path(self) -> Path:
        return self._path

    @path.setter
    def path(self, path) -> None:
        self._path = path

    @property
    def search_pattern(self):
        return self._search_pattern
