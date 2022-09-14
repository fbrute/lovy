from __future__ import unicode_literals
import config
import simulation
import simulationtype
import simulationfactory
import _tkinter
import tkinter
import unittest.mock


class TestSimulationFactory(unittest.TestCase):
    """ Test the creation of a Simulation """
    def setUp(self):
        self.root = tkinter.Tk()
        self.pump_events()

    def tearDown(self):
        if self.root:
            self.root.destroy()
            self.pump_events()

    def pump_events(self):
        while self.root.dooneevent(_tkinter.ALL_EVENTS | _tkinter.DONT_WAIT):
            pass

    def test_make_simulation_without_proper_simulation_type(self):
        with self.assertRaises(TypeError):
            sim = simulationfactory.make_simulation(
                simulation_type="not_good_enough_type"
            )
            self.assertTrue(sim is None)

    def test_make_simulation_with_proper_simulation_type(self):
        # config_factory = unittest.mock.Mock(spec=configfactory)
        with unittest.mock.patch('configfactory.make_config') as mock:
            mock.return_value = config.ConfigTest()
            sim = simulationfactory.make_simulation(
                simulation_type=simulationtype.SimulationType.TEST
            )
            self.assertTrue(isinstance(sim, simulation.Simulation))
            mock.assert_called_once()
            self.assertTrue(isinstance(sim.config, config.Config))


if __name__ == '__main__':
    unittest.main()
