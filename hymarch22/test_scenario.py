#!/usr/bin/env python3
import unittest
from scenario import Scenario
from datetime import date
from pathlib import Path
from config import Config

class TestScenario(unittest.TestCase):
  """ Test Scenario class """

  def test_scenario_path(self):
    sc = Scenario('background_air', mode='test')
    self.assertTrue(sc.path.is_dir())

  def test_result_path(self):
    sc = Scenario('background_air', mode='test')
    self.assertTrue(sc.result_path.is_dir())
  
  def test_get_scenario_dates_files(self):
    sc = Scenario('background_air', mode='test')
    files = sc.get_files()
    self.assertEqual(len(files), 3)

  def test_get_dates(self):
    sc = Scenario('background_air', mode='test')
    files = sc.get_files()
    # we check the first file ("barb...")
    string_of_dates = sc.get_dates(files[0])
    nb_dates = sc.get_nb_dates(string_of_dates)
    self.assertTrue(len(nb_dates) >= 2)
  
  def test_get_station(self):
    sc = Scenario('background_air', mode='test')
    files = sc.get_files()
    file = files[0]
    station = sc.get_station(file)
    self.assertEqual(station, 'barb')

  def test_get_bts(self):
    sc = Scenario('background_air', mode='test')
    sc.get_bts()
  
  def test_get_unique_dates(self):
    sc = Scenario('background_air', mode='test')
    nb_unique_dates = sc.stat(sc.files[0])
    self.assertEqual(nb_unique_dates, 2)
  
  def test_stat(self):
    sc = Scenario('background_air', mode='test')
    nb_unique_dates =  sc.stat(sc.files[0])
    self.assertEqual(nb_unique_dates, 2)
  
  def test_file_is_gis_related(self):
    sc = Scenario('background_air', mode='test')
    is_gis_related = sc.file_is_gis_related('compassion.shx')
    self.assertTrue(is_gis_related)

    is_gis_related = sc.file_is_gis_related('compassion.shp')
    self.assertTrue(is_gis_related)

    is_gis_related = sc.file_is_gis_related('compassion.dbf')
    self.assertTrue(is_gis_related)

    is_gis_related = sc.file_is_gis_related('compassion.prj')
    self.assertTrue(is_gis_related)

    is_gis_related = sc.file_is_gis_related('compassion.txt')
    self.assertFalse(is_gis_related)
  
  def test_file_is_shp_related(self):
    sc = Scenario('background_air', mode ='test')
    self.assertTrue(sc.file_is_shp_related('compassion.shp'))
    self.assertFalse(sc.file_is_shp_related('compassion.shx'))


if __name__ == "__main__":
  unittest.main()