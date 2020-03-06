import picnum
import unittest

class TestPicnumMethods(unittest.TestCase):

  def setUp(self):
    self.bts = picnum.BtsLoad("/Users/france-norbrute/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data_test/puer/picnums")

  def test_getPicnum(self):
    picnum = self.bts.getPicnum("filename_888")
    self.assertEquals(picnum, "888")
  
  if __name__ == '__main__':
    unittest.main()

