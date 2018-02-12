#!/usr/bin/env ruby -w
=begin
This scripts is supposed to receive a list of dates
of D3 (dusty days)
It comes from mysql so dates are 'yyyy-mm-dd'
=end

require 'date'
require 'fileutils'
include FileUtils
BEGIN
SOURCE_FOLDER="/Users/france-norbrute/Documents/trafin/fouyol/recherche/Hysplit4/karu_retros_test"
Dir.chdir(SOURCE_FOLDER)
END

def create_season_folders
    %w( NDJF MA MJJA SO).each do |season| 
    Dir.mkdir(season) if !File::directory?(season)
end

#Dir.mkdir("NDJF") if !File::directory?("NDJF")
#Dir.mkdir("NDJF") if !File::directory?("NDJF")
#Dir.mkdir("MA") if !File::directory?("NDJF")
#Dir.mkdir("MJJA") if !File::directory?("MJJA")
 
ARGF.each do |date|
    puts date
end

def get_season(date)
end

def flatten
    Dir.glob("**/*.*").each do |file| cp(file,".") end

    Dir.glob("**/*") do |file|
        begin
            #puts file.match(/\d{6}/)[0] 
            year  = file.match(/(\d{2})(\d{2})(\d{2})/)[1] 
            month = file.match(/(\d{2})(\d{2})(\d{2})/)[2] 
            day   = file.match(/(\d{2})(\d{2})(\d{2})/)[3] 
        rescue
        end
        # Format dates according to actual values previously computed with hysplit
        date  = "20#{year}-#{month}-#{day}"
            
        #

        if ARGF.include?(date)
            case month
                when /11|12|01|02/
                    puts "DFJ"
                else
                    puts "can't find season!!"
            end
            #join( 
            #cp(file,
        end
    end
end
