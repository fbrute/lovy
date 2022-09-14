import multi_days
import unittest
from project import Project

class TestHymarch22(unittest.TestCase):
  """ Test Project Hymarch22"""

  def test_project_name(self):
    """ Test the name of the project"""

    md = Project("Hymarch22")
    self.assertEqual(md.name, "Hymarch22")

  def test_folder_hierarchy(self):
    """ Test we hav a proper hierarchy for the results folder """
    md = Project("Hymarch22")
    self.assertTrue(md.check_project_root_folder())
    self.assertTrue(md.check_data_folder())
    self.assertFalse(md.check_result_folders())
    self.assertTrue(md.prepare_results_folders())

if __name__ == '__main__':
  unittest.main()