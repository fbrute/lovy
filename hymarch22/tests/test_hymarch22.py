#!/usr/bin/env python3

import unittest
from scenario import Scenario
from datetime import date
from pathlib import Path
from config import Config
from hymarch22_v2 import Hymarch22

class TestHymarch22(unittest.TestCase):
  """ Test Hymarch22 class """

  def setUp(self):
    self.hy = Hymarch22(scenario_name='background_air')

  def test_hymarch22_path(self):
    self.assertTrue(self.hy.path.is_dir())
  
  def test_get_shp_files(self):
    self.assertEqual(len(list(self.hy.getShpFiles(self.hy.path))), 1571)
  
  def tearDown(self) -> None:
    return super().tearDown()



if __name__ == "__main__":
  unittest.main()