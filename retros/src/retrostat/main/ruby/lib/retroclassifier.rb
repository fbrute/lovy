#!/usr/bin/env ruby

# France-Nor Brute, January 24, 2018
# expect to class a folder etros files to proper seasons according to dates incorporated in name of d3 (yyyy-mm-dd) file passed as an argument

require 'fileutils'

class RetroClassifier
    attr_reader :folder

    def initialize(folder)
        @folder = folder 
        Dir.chdir(folder)

        %q(NDJF MA MJJA SO).split.each do |dir|
            FileUtils.mkdir_p File.join 'D3',  dir
            FileUtils.mkdir_p File.join 'ND3',  dir
        end
    end

    def month(date)
        date.match(/(\d{2})(\d{2})(\d{2})/)[2]
    end
    
    def date(date)
        date = date.match(/(\d{2}\d{2}\d{2})/)[0]
        date.gsub(/(\d{2})(\d{2})(\d{2})/,'20\1-\2-\3')
    end
    
    def classify(dates)
        puts "dates.last.length=#{dates.last.length}"
        Hash["NDJF" => %w(11 12 01 02),
             "MA" => %w(03 04),
             "MJJA" => %w(05 06 07 08),
             "SO" => %w(09 10)].each do |key,val|
            #(Dir.glob("*.dbf") + Dir.glob("*.shp") + Dir.glob("*.shx") + Dir.glob("*.prj")).each do |file| 
            (Dir.glob("**/*/*.dbf") + Dir.glob("**/*/*.shp") + Dir.glob("**/*/*.shx") + Dir.glob("**/*/*.prj")).each do |file| 
                    if val.include? month(file) 
                        if dates.include? date(file)
                            FileUtils.mv(file,File.join('.','D3',key) ) 
                        else
                            FileUtils.mv(file,File.join('.','ND3',key)) 

                        end
                    end
            end
        end
    end
end
