# frozen_string_literal: true

require_relative 'trajectory_stat'
require_relative 'getPm10FromDate'
require 'fileutils'
require 'date'

class TrajectoryStatForOneBacktraj

  attr_accessor :gate_stats
  attr_accessor :dates_stats
  attr_accessor :pm10s_stats

  include GetPm10
  include FileUtils


  def initialize(station, level, date)

    @station = station
    @level = level
    @date = Date.parse date

    @gates = []
    @gates << @nwap = Gate.new(:nwap, 35, -16, 10, -20)
    @gates << @swap = Gate.new(:swap, 10, -16, 0, -20)
    @gates << @neap = Gate.new(:neap, 35, -20, 20, -50)
    @gates << @sa = Gate.new(:sa, 10, -30,   0, -50)
    @gates << @north = Gate.new(:north, 30,  -50, 20, -60)
    # Arbitrary values for ind gate not overlaying nwap, swap or neap
    @gates << @ind = Gate.new(:ind, 90, 80, 80, 70)

    # stats at gate level without seasons (april 2022)
    @gate_stats = { neap: 0, nwap: 0, swap: 0, ind: 0,sa: 0,north: 0 }
    @dates_stats = { neap: [], nwap: [], swap: [], ind: [],sa: [],north: [] }
    @pm10s_stats = { neap: [], nwap: [], swap: [], ind: [],sa: [],north: [] }

    begin
      @file = File.join(
        ENV["RES_PATH_DIR"],
        "#{station}_#{level}",
        "#{@date.year}",
        "tdump#{@date.strftime('%y%m%d')}.txt"
      )
    rescue TypeError
      puts "could not find tdump file"
    end
  end

  def file
    @file
  end

  def date
    @date
  end


  def date6(file)
    date = file.match(/(\d{2}\d{2}\d{2})/)[0]
  end

  def gates
    @gates
  end

  def traj()
    aresults = []
    `awk '/12/ {print $10, $11;}' #{@file}`.split("\n").each .reject { |latlon| latlon == ' ' }
                                          .each { |latlon| aresults << latlon }
    aresults
  end

  def count_one_backtraj
      trajectory = traj
      trajclass = TrajectoryClassifier.new gates, trajectory
      path = trajclass.path gates

      if gates.any? { |gate| gate.name == path }
        path
      else
        'none'
      end
  end
end
