#!/usr/bin/env ruby
require_relative 'retroclassifier'

def main(folder, file)
    if folder && file 
            folder = File.expand_path folder 
            d3datesfile = File.expand_path file
                if File.exists? d3datesfile
                    d3dates = IO.readlines(d3datesfile).each {|date| date.chomp!}
                end
        else
            exit -9 
        end
    rc = RetroClassifier.new(folder)
    rc.classify(d3dates)
end

main(ARGV[0], ARGV[1])

