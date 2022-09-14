from enum import Enum


def is_station(station):
    try:
        names = set([member.name for member in Station])
        if station.name in names:
            return True
        else:
            return False
    except AttributeError:
        print("Station does not exist")


class DateFormat(Enum):
    """ Enum for date formats"""
    DMY = 1
    YMD = 2


class Station(Enum):
    """ Enum for stations"""
    BARB = 1
    CUBA = 2
    KARU = 3
    MADA = 4
    PUER = 5
    SMAR = 6

    def __str__(self):
        return str(self.name.lower())


class EmptyFolderError(Exception):
    pass
