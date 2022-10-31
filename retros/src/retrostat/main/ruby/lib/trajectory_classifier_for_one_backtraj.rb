#!/usr/bin/env ruby
# frozen_string_literal: true

# get a gate in (nwap, swap, neap, sa, north, ind ) for a particular backtraj (station, level, date)
# the above params are required and expected
# used with django lovysimulation to get the gate associated to a Backtraj model.

require_relative 'trajectory_stat_for_one_backtraj'
require 'descriptive_statistics'
require 'byebug'
require 'date'

def contains_trajectories? folder
    !Dir.glob("#{folder}/**/*/tdump*").empty?
end

#def getD3dates folder
#    d3dates = Dir.glob("#{folder}/*").select { |file| File.directory? file } . select { |file| file.contains? 'd3' }
#    if d3dates.any? match
#end

def traj_folders folder
    Dir.glob("#{folder}/**/*/tdump*")
end

def name folder
    if folder.match(/karu|mada|puer|barb/) then folder.match(/karu|mada|puer|barb/)[0]
    else nil
    end
end

def level folder
    if folder.match(/1500|2000|3000|4000|5000/) then folder.match(/1500|2000|3000|4000|5000/)[0]
    else nil
    end
end


raise "No station !!!" unless ARGV[0]
station = ARGV[0]

raise "No level provided!!!" unless ARGV[1]
level = ARGV[1]

raise "No date provided!!!" unless ARGV[2]
date = ARGV[2]

raise "The station #{ARGV[0]} is not handled}" unless %w( barb cuba karu mada puer ).include? ARGV[0]

raise "The level #{ARGV[1]} is not handled}" unless %w( 1500 2000 3000 4000 5000 ).include? ARGV[1]

raise "The date is not provided!!!" unless ARGV[2]
backtraj_date = Date.parse ARGV[2]

raise "The date #{backtraj_date} is not in the right range (year 2006 to 2016)" unless backtraj_date.year.between? 2006, 2016

tstat = TrajectoryStatForOneBacktraj.new station, level, date
gate = tstat.count_one_backtraj
puts gate