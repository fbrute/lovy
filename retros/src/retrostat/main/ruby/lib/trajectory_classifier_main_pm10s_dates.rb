#!/usr/bin/env ruby
require_relative 'trajectory_stat_d3_pm10s_dates'
require 'descriptive_statistics'

def contains_trajectories? folder
    !Dir.glob("#{folder}/**/*/tdump*").empty?
end

#def getD3dates folder
#    d3dates = Dir.glob("#{folder}/*").select { |file| File.directory? file } . select { |file| file.contains? 'd3' }
#    if d3dates.any? match 
#end

def traj_folders folder
    Dir.glob("#{folder}/**/*/tdump*").select { |file| File.directory? file } . reject { |file| file.contains? 'd3' }
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

raise "No folder provided!!!" if !ARGV[0]
folder = ARGV[0]

raise "No pm10csv file provided!!!" if !ARGV[1]
pm10_csv_file = ARGV[1]

if  !ARGV[2].nil? && ARGV[2].to_i > 0
    threshold = ARGV[2].to_i
else
    threshold = 0
end




raise "Folder does not exists!!!" if !Dir.exists?(folder)
#raise "Folder name should contain karu or mada, puer or barb, please check!!!" if !name(folder)
files = Dir.glob("**/*/tdump*")
raise "Folder does not contain any trajectories, please check!!!" if !contains_trajectories?(folder)

#raise "File containing dates does not exists!!!" if !File.exists?(file)

#traj_folders(folder).each do |traj_folder| 

    tstat = TrajectoryStatD3Pm10sDates.new folder, pm10_csv_file, threshold
    #tstat = TrajectoryStat.new folder
    #tstat.count
    tstat.count_by_seasons_pm10s_dates

    ntotal = 0

    File.open(File.basename(folder) + "_stat.txt" ,"w+") do |output_file|
        output_file.write "***********#{name(folder)} @ #{level(folder)}*************\n"
        [tstat.ndjf, tstat.ma, tstat.mjja, tstat.so].each do |tstat|
            output_file.write (tstat[:name].to_s + "\n")
            [:nwap, :swap, :neap, :sa, :north, :ind].each do |gate| 

                ntotal +=  tstat[gate][:total]
                #puts ">nwap count = #{tstat[:nwap]}" 
                output_file.write "> #{gate} count = #{tstat[gate][:total]}\n" 
                output_file.write "> #{gate} pm10mean = #{tstat[gate][:pm10s].mean}\n" 
                output_file.write "> #{gate} std = #{tstat[gate][:pm10s].standard_deviation}\n" 
                output_file.write "> #{gate} median = #{tstat[gate][:pm10s].median}\n" 
            end
        end 

        output_file.write "total de trajectoires traitées =#{ntotal}\n"
        output_file.write "total de trajectoires dans le dossier =#{tstat.files.length}\n"
        #output_file.write "total d3dates=#{tstat.length}\n"
        
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
#end 

    
    

