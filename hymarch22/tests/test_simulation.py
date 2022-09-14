import unittest
from simulation import Simulation
from scenario import Scenario
from datetime import date
from pathlib import Path
from config import Config


class TestSimulation(unittest.TestCase):
    """ Test Simulation class """
    def test_simulation_path(self):
        sim = Simulation('Hymarch22', mode='test')
        self.assertTrue(sim.name == 'Hymarch22')


if __name__ == "__main__":
    unittest.main()
