#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'trajectory_stat_d3_pm10s_dates_threshold'
require 'descriptive_statistics'
require 'byebug'

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


raise "No folder with tdump provided!!!" if !ARGV[0]
folder = ARGV[0]

raise "No pm10csv file provided!!!" if !ARGV[1]
pm10_csv_file = ARGV[1]

# handle operator for threshold
operators = %i( >= > < <= )
if  !ARGV[2].nil? && (operators.include? ARGV[2].to_sym)
    operator = ARGV[2].to_sym
else
    operator = :<= 
end


if  !ARGV[3].nil? && ARGV[3].to_i > 0
    threshold = ARGV[3].to_i
else
    threshold = 0
end

raise "Folder does not exists!!!" if !Dir.exists?(folder)
raise "Folder name should contain karu or mada, puer or barb, please check!!!" if !name(folder)


#files = Dir.glob("**/*/tdump*")
raise "Folder does not contain any trajectories, please check!!!" if !contains_trajectories?(folder)


tstat = TrajectoryStatD3Pm10sDatesWithThreshold.new folder, pm10_csv_file, operator = operator , threshold
tstat.count_by_gates_with_pm10s_and_dates

ntotal = 0

def pourcentage(gate_count, season_count)
    ((gate_count.to_f / season_count) * 100 ).round(2)
    rescue ZeroDivisionError
       -9 
end

operator_string = "operator"
if operator == :<
    operator_string = "lt"
elsif operator == :>
    operator_string = "gt"
elsif operator == :>=
    operator_string = "ge"
elsif operator == :<=
    operator_string = "le"
end

File.open(File.basename(folder) + "_#{operator_string}_#{threshold}" + "_stat_synthesis_by_gates.txt" ,"w+") do |output_file|
    CSV.open(File.basename(folder) +  "_#{operator_string}_#{threshold}" + "_stat_synthesis_by_gates_details.csv" ,"w+") do |csv|
        output_file.write "***********#{name(folder)} @ #{level(folder)}*************\n"
        [:nwap, :swap, :neap, :sa, :north, :ind].each do |gate| 
            byebug
            ntotal +=  tstat[gate][:total]
            #puts ">nwap count = #{tstat[:nwap]}" 
            sup_inf_stats = DescriptiveStatistics::Stats.new(tstat[gate][:pm10s])

            output_file.write "> #{gate} count = #{tstat[gate][:total]}\n" 
            output_file.write "> #{gate}/#{tstat[:name]} = #{pourcentage(tstat[gate][:total], tstat[:total])}%\n" 
            if tstat[gate][:total] > 0
                output_file.write "> #{gate} pm10mean = #{tstat[gate][:pm10s].mean.round(2)}\n" 
                output_file.write "> #{gate} min = #{sup_inf_stats.min.round(2)}\n" 
                output_file.write "> #{gate} max = #{sup_inf_stats.max.round(2)}\n" 
                output_file.write "> #{gate} std = #{tstat[gate][:pm10s].standard_deviation.round(2)}\n" 
                output_file.write "> #{gate} median = #{tstat[gate][:pm10s].median.round(2)}\n" 
                output_file.write "> #{gate} skewness = #{sup_inf_stats.skewness.round(3)}\n" 
                output_file.write "> #{gate} kurtosis = #{sup_inf_stats.kurtosis.round(3)}\n" 
            end

            dates_pm10s = [tstat[gate][:dates], tstat[gate][:pm10s]].transpose
            dates_pm10s.each do |date,pm10|
                csv << [tstat[:name].to_s, gate.to_s, date, pm10]
            end 
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