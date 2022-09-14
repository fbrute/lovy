import unittest

from backtraj import BackTrajMode, BackTrajLevel
from backtrajfactory import BackTrajFactory
from datetime import date
import configfactory
from pathlib import Path
import shutil
from unittest.mock import patch
from simulationtype import SimulationType
from utils import Station


class TestBackTrajFactory(unittest.TestCase):
    def setUp(self) -> None:

        # ensure the test folder is empty
        self.test_path = Path("/media/kwabena/MODIS/hysplit_data/tests/retros_simulations")
        shutil.rmtree(self.test_path, ignore_errors=True)
        self.config_test = configfactory.ConfigFactory.make_config(sim_type=SimulationType.TEST)
        self.config_test = configfactory.ConfigFactory.make_config(sim_type=SimulationType.TEST)

        self.bt_ok_test = configfactory.BackTrajFactory.make_backtraj(
            config=self.config_test,
            station=Station.BARB,
            date_of_backtraj=date(2006, 7, 1),
            level=BackTrajLevel.LEVEL1500,
            mode=SimulationType.TEST,
        )

        self.config_prod = configfactory.ConfigFactory.make_config(sim_type=SimulationType.PROD)
        self.assertFalse(self.config_prod is None)

        self.bt_ok_prod = BackTrajFactory.make_backtraj(
            config=self.config_prod,
            station=Station.BARB,
            date_of_backtraj=date(2006, 7, 1),
            level=BackTrajLevel.LEVEL1500,
            mode=SimulationType.PROD,
        )

    def test_make_backtraj_with_no_arguments(self):
        with self.assertRaises(TypeError):
            BackTrajFactory.make_backtraj()

    def test_make_backtraj_with_invalid_config(self):
        with patch('configfactory.ConfigFactory') as mock_config:
            instance = mock_config.return_value
            instance.make_config.return_value = "result_value"
            with self.assertRaises(TypeError):
                BackTrajFactory.make_backtraj(config=None)

    @unittest.skip("test later")
    def test_make_backtraj_with_valid_config_and_invalid_station(self):
        with self.assertRaises(TypeError):
            BackTrajFactory.make_backtraj(config=self.config_test, station="barb")

    @unittest.skip("test later")
    def test_make_backtraj_with_valid_config_and_valid_station(self):
        with self.assertRaises(TypeError):
            BackTrajFactory.make_backtraj(config=self.config_test, station=Station.BARB)

    @unittest.skip("test later")
    def test_make_backtraj_with_valid_config_and_invalid_date(self):
        bt = BackTrajFactory.make_backtraj(
            config=self.config_test,
            station=Station.BARB,
            date_of_backtraj=date(1998, 1, 1)
        )
        self.assertTrue(bt is None)

    @unittest.skip("test later")
    def test_make_backtraj_with_valid_config_station_and_date(self):
        """ level, mode and date_format contains default values """
        bt = BackTrajFactory.make_backtraj(
            config=self.config_test,
            station=Station.BARB,
            date_of_backtraj=date(2006, 1, 1)
        )
        self.assertTrue(bt is not None)

    @unittest.skip("test later")
    def test_make_backtraj_and_check_results_generated_bts_folder_with_a_test_config(self):
        self.assertEqual(
            self.bt_ok_test.path,
            Path(
                "/media/kwabena/MODIS/hysplit_data/tests/retros_simulations/" +
                f"{self.bt_ok_test.station}_" +
                f"{self.bt_ok_test.level}/{self.bt_ok_test.bts_date.year}"
            )
        )

    @unittest.skip("test later")
    def test_make_backtraj_and_check_results_generated_bts_folder_with_a_prod_config(self):
        self.assertEqual(
            self.bt_ok_prod.path,
            Path(
                "/media/kwabena/MODIS/hysplit_data/retros_mars_2018/" +
                f"{self.bt_ok_test.station}_" +
                f"{self.bt_ok_test.level}/{self.bt_ok_test.bts_date.year}"
            )
        )

    @unittest.skip("test later ...")
    def test_exists(self):
        bt = BackTrajFactory.make_backtraj(
            config=self.config_test,
            date_of_backtraj=date(2012, 6, 1),
            station=Station.BARB,
            level=BackTrajLevel.LEVEL1500,
            mode=BackTrajMode.TEST
        )

        self.assertFalse(bt.exists())

        bt.generate()

        self.assertTrue(bt.exists())

    @unittest.skip("test later")
    def test_get_files(self):
        """ Test we get the proper bt files"""
        bt = BackTrajFactory.make_backtraj(
            self.config_test,
            Station.KARU,
            date(2007, 11, 9),
            level=BackTrajLevel.LEVEL1500,
            mode=SimulationType.TEST
        )
        self.assertFalse(bt.exists())

        bt.generate()

        self.assertTrue(bt.exists())

    @unittest.skip("test later ...")
    def test_get_ymd_date_string_from_date(self):
        bt = BackTrajFactory(
            station='barb',
            bts_date='09/11/2007',
            level=1500,
            date_format='dmy',
            mode='test'
        )
        ymd = bt.get_ymd_date_string_from_date(date(2007, 11, 9))
        self.assertEqual(ymd, '071109')

    @unittest.skip("test later ...")
    def test_generate(self):
        bt = BackTrajFactory(
            station='barb',
            bts_date='20/02/2014',
            level=1500,
            mode='test',
            date_format='dmy')
        self.assertFalse(bt.exists())
        if not bt.exists():
            bt.generate()
        self.assertTrue(bt.exists())


if __name__ == '__main__':
    unittest.main()
