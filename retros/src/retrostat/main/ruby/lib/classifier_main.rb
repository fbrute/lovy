#!/usr/bin/env ruby

# Author : France-Nor Brute, Copyright 2018
#
# This script takes two arguments :
# 1. a folder containing bts 
# 2.a d3 files with yyyy-mm-dd format
#
# When launched, D3 and ND3 folders are created and contains classifed d3 to seasons.
#
require_relative 'retroclassifier'

def main(folder, file)
    if folder && file 
            folder = File.expand_path folder 
            d3datesfile = File.expand_path file
                if File.exists? d3datesfile
                    d3dates = IO.readlines(d3datesfile).each {|date| date.chomp!}
                end
        else
            print "Please supply folder to be classified by D3/ND3/Seasons and d3 files as parameters\n"
            exit -9 
        end
    rc = RetroClassifier.new(folder)
    rc.classify(d3dates)

    #exec "zip -r #{folder}_D3_ND3_by_seasons_2006_2016.zip D3 ND3"

    puts "d3  classified count = #{Dir.glob("#{folder}/D3/**/*.prj").count}"
    puts "nd3 classified count = #{Dir.glob("#{folder}/ND3/**/*.prj").count}"
end

main(ARGV[0], ARGV[1])

