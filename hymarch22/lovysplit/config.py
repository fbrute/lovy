from abc import ABC
from enum import Enum
from pathlib import Path, PosixPath


class ConfigType(Enum):
    """ Enum for config types """
    PROD = 1
    TEST = 2

    def __repr__(self):
        return self.name.lower()

    def __str__(self):
        return self.name.lower()


class Config(ABC):
    """ Implemented as a singleton """
    __unique_instance = None

    def __init__(self, name='default_config'):
        if not Config.__unique_instance:
            Config.__unique_instance = self
            Config.__unique_instance.name = name

    @classmethod
    def get_instance(cls):
        return Config.__unique_instance

    @staticmethod
    def get_root_path(cls):
        return(Path("/home/kwabena/Documents/trafin/lovy"))

    @staticmethod
    def get_input_data_path() -> PosixPath:
        return(Path("/home/kwabena/Documents/trafin/lovy/input_data"))

    def get_met_root_path(self) -> PosixPath:
        return("get_met_root_path() is an abstract method")

    @classmethod
    def get_project_root(cls) -> PosixPath:
        return(Path("/home/kwabena/Documents/trafin/lovy/hymarch22/lovysplit"))

    @classmethod
    def get_res_root(cls) -> PosixPath:
        return(Path(f"/media/kwabena/MODIS/{cls.get_instance().name}"))

    @classmethod
    def get_name(cls) -> list:
        return(cls.get_instance().name)


class ConfigTest(Config):
    def get_met_root_path(self) -> PosixPath:
        return Path("/media/kwabena/MODIS/hysplit_data/tests/retros_simulations")


class ConfigProd(Config):
    def get_met_root_path(self) -> PosixPath:
        return Path("/media/kwabena/MODIS/hysplit_data/retros_mars_2018")
