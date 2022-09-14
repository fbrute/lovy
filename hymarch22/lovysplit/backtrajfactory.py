#!/usr/bin/env python3

from backtraj import BackTraj, BackTrajMode, BackTrajLevel
from config import Config, ConfigProd, ConfigTest
from datetime import date
from simulationtype import SimulationType
from utils import Station, is_station


class BackTrajFactory:
    @staticmethod
    def make_backtraj(
        config: Config,
        station: Station,
        date_of_backtraj: date,
        level: BackTrajLevel = BackTrajLevel.LEVEL1500,
        mode: BackTrajMode = SimulationType.TEST,
    ):

        try:
            if type(config) not in (ConfigTest, ConfigProd):
                raise TypeError("This config is unhandled!")

            if not is_station(station):
                raise TypeError("Station is unknown!")

            if not BackTraj.is_valid_date(date_of_backtraj):
                # breakpoint()
                raise ValueError("The date is not valid!")

            if level not in BackTrajLevel:
                raise TypeError("This level is unhandled!")
                return None

            if not isinstance(mode, SimulationType):
                raise TypeError("This mode is unhandled!")
                return None

            return(BackTraj(config, station, date_of_backtraj, level, mode))

        except (TypeError, ValueError) as e:
            print(f"""BackTraj for {station} at date: {date_of_backtraj.strftime("%d/%m/%Y")} ,
                config: {config},level {level},
                mode: {mode}
                not created!!, with e={e}""")
            return None
