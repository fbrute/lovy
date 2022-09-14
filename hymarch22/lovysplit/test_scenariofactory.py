from pathlib import Path
from scenariofactory import ScenarioFactory
import os.path
import unittest


class TestScenarioFactory(unittest.TestCase):

    def test_create_scenario_without_arguments(self):
        sc = ScenarioFactory.make_scenario()
        self.assertTrue(sc is None)

    def test_create_scenario_with_valid_excel_file_path(self):
        excel_file_path = Path(
            os.path.join(
                "/home/kwabena/Documents/",
                "trafin/lovy/hymarch22/",
                "input_data/hysplit_days_v3.xlsx"
            )
        )
        sc = ScenarioFactory.make_scenario(excel_file_path=excel_file_path)
        self.assertTrue(sc is not None)


if __name__ == '__main__':
    unittest.main()
