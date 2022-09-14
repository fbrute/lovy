from config import ConfigType
from configfactory import ConfigFactory
import unittest


class TestConfigFactory(unittest.TestCase):
    def setUp(self):
        self.config_ok = ConfigFactory.make_config(config_type=ConfigType.TEST)

    def test_


if __name__ == '__main__':
    unittest.main()
