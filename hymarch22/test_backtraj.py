#!/usr/bin/env python3

from this import d
import unittest
from backtraj import Backtraj
from datetime import date
from pathlib import Path
from config import Config

class TestBacktraj(unittest.TestCase):
  """ Test Backtraj class """
  def setUp(self) -> None:
      return super().setUp()
    
  def test_mdy(self):
    bt = Backtraj( 'karu', '01/07/2009', date_format='dmy', mode='test')
    self.assertEqual(bt.bts_date, date(bt.bts_date.year, bt.bts_date.month, bt.bts_date.day))

  def test_folder_name(self):
    """ Test the folder name of the backtraj"""
    config = Config()
    station = 'karu'
    bt = Backtraj(station, '07/11/2007', level=1500, date_format='dmy', mode='test')
    path = Config.get_met_root() / '..'/ 'tests' /  'retros_mars_2018' / 'karu_1500'
    self.assertTrue(path.is_dir())
    self.assertEqual(bt.path, bt.path)
  
  def test_exists(self):
    bt = Backtraj(bts_date='15/02/2014', station='barb', level=1500, date_format='dmy', mode='test')
    self.assertFalse(bt.exists())
    bt = Backtraj(bts_date='19/02/2014', station='barb', level=1500, date_format='dmy', mode='test')
    self.assertTrue(bt.exists())

  def test_get_files(self):
    """ Test we get the proper bt files"""
    station = 'karu'
    bt = Backtraj(station, '09/11/2007', level=1500, date_format='dmy', mode='test')
    files = bt.get_files()
    #self.assertEqual(len(files), 7)

  def test_get_ymd_date_string_from_date(self):
    bt = Backtraj(station='barb', bts_date='09/11/2007', level=1500, date_format='dmy', mode='test')
    ymd = bt.get_ymd_date_string_from_date(date(2007,11,9))
    self.assertEqual(ymd, '071109')


  def test_generate(self):
    bt = Backtraj(station='barb', bts_date = '20/02/2014', level=1500, mode='test', date_format='dmy' )
    self.assertFalse(bt.exists())
    if not bt.exists():
      bt.generate()
    self.assertTrue(bt.exists())

if __name__ == '__main__':
  unittest.main()