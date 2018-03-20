#!/usr/bin/env ruby
require_relative 'trajectory_stat_d3'
#!/usr/bin/env ruby

# Author : France-Nor Brute, Copyright 2018
#
# This script takes two arguments :
# 1. a folder containing bts 
# 2.a d3 files with yyyy-mm-dd format
#
# When launched a file containing results of classification is produced

def main(folder, file)
    raise "No folder provided!!!" if !ARGV[0]
    raise "No D3 file provided!!!" if !ARGV[1]
    raise "Folder does not exists!!!" if !Dir.exists?(folder)

    #raise "Folder name should contain karu or mada, puer or barb, please check!!!" if !name(folder)
    raise "Folder does not contain any trajectories, please check!!!" if !contains_trajectories?(folder)
    raise "File containing dates does not exists!!!" if !File.exists?(file)
end

class folder
    :attr_reader name, path

    def initialize path
        @file =  
        @name = folder
    end

    def traj_folders folder
        Dir.glob("#{folder}/*").select { |file| File.directory? file } . reject { |file| file.contains? 'd3' }
    end

    def name
        if folder.match(/karu|mada|puer|barb/) then folder.match(/karu|mada|puer|barb/)[0]
        else nil
        end
    end

    def contains_trajectories? folder
        !Dir.glob("#{folder}/**/*/tdump*").empty?
    end

end


#def getD3dates folder
#    d3dates = Dir.glob("#{folder}/*").select { |file| File.directory? file } . select { |file| file.contains? 'd3' }
#    if d3dates.any? match 
#end


def level folder
    if folder.match(/1500|2000|3000|4000|5000/) then folder.match(/1500|2000|3000|4000|5000/)[0]
    else nil
    end
end


class RetroStat
    def initialize
    end
    
    def classify
        traj_folders.each do |traj_folder| 

            d3datesfile = File.expand_path traj_folder.file

            # Ensure that dates or unique
            d3dates = IO.readlines(d3datesfile).each {|date| date.chomp!}.uniq

            tstat = TrajectoryStatD3.new folder, d3dates, PathWithoutEnd
            #tstat.count
            #
            tstat.count_by_seasons

            ntotal = 0

            File.open(File.basename(folder) + "_stat.txt" ,"w+") do |output_file|
                output_file.write "***********#{name(folder)} @ #{level(folder)}*************\n"
                [tstat.ndjf, tstat.ma, tstat.mjja, tstat.so].each do |tstat|
                    output_file.write (tstat[:name].to_s + "\n")

                    [:nwap, :swap, :neap, :sa, :north, :ind].each do |gate| 
                        ntotal +=  tstat[gate]
                        output_file.write ">nwap count = #{tstat[:nwap]}\n"
                    end

                output_file.write "total de trajectoires traitées =#{ntotal}\n"
                output_file.write "total de trajectoires dans le dossier =#{tstat.files.length}\n"
                output_file.write "total d3dates=#{d3dates.length}\n"
                
                output_file.write "************************\n"
                output_file.write "************************\n"
                tstat.gates.each do |gate|
                    output_file.write "gate name  = #{gate.name}\n"
                    output_file.write ">north limit = #{gate.north}\n"
                    output_file.write ">south limit = #{gate.south}\n"
                    output_file.write ">west limit = #{gate.west}\n"
                    output_file.write ">east limit = #{gate.east}\n"
                    output_file.write "\n"
                end
                output_file.write "************************\n"
                output_file.write "************************"
            end 
        end 
    end 
end 


main(ARGV[0], ARGV[1])
