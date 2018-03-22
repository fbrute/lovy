#!/usr/bin/env ruby -w
require 'fileutils'
include FileUtils

# Use this script before trajectory_classifier_main.rb

exit if ARGV.length == 0

Dir.chdir(ARGV[0])
folders=Array.new
folders << Dir.glob("*")
Dir.glob("**/*.*").each do |file| cp(file,".") end
#folders.each { |folder| Dir.delete folder}