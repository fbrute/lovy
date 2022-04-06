#!/usr/bin/env python3
# Karusphere, copyright Marc 2022
# launch a simulation with all the scenarios
# the source of the bts is available on MODIS

from config import Config
from scenario import Scenario
import sys

class Simulation:
  def __init__(self, name, mode='test'):
    self.name = name
    self.scenarios_names = Config.get_scenarios_names()
    self.mode = mode
    self.run()
  
  def run(self):
    for scenario_name in self.scenarios_names:
      scenario = Scenario(scenario_name, mode= self.mode)
      scenario.get_bts()

if __name__ == "__main__":
  mode=str(input("which mode ? (test|prod)"))
  sim = Simulation("Hymarch22", mode=mode)
  sim.run()