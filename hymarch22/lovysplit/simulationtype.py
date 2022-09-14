from enum import Enum


class SimulationType(Enum):
    """ Enum for config types """
    PROD = 1
    TEST = 2

    def __repr__(self):
        return self.name.lower()

    def __str__(self):
        return self.name.lower()
