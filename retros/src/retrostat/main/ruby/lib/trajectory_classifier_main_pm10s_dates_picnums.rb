#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'trajectory_stat_d3_pm10s_dates_picnums'
require 'descriptive_statistics'
require 'descriptive-statistics'

def contains_trajectories?(folder)
  !Dir.glob("#{folder}/**/*/tdump*").empty?
end

# def getD3dates folder
#    d3dates = Dir.glob("#{folder}/*").select { |file| File.directory? file } . select { |file| file.contains? 'd3' }
#    if d3dates.any? match
# end

def traj_folders(folder)
  Dir.glob("#{folder}/**/*/tdump*").select { |file| File.directory? file } . reject { |file| file.contains? 'd3' }
end

def name(folder)
  folder.match(/karu|mada|puer|barb/)[0] if folder.match(/karu|mada|puer|barb/)
end

def level(folder)
  if folder.match(/1500|2000|3000|4000|5000/) then folder.match(/1500|2000|3000|4000|5000/)[0]
  end
end

raise 'No folder provided!!!' unless ARGV[0]

folder = ARGV[0]

raise 'No pm10csv file provided!!!' unless ARGV[1]

pm10_csv_file = ARGV[1]

threshold = if  !ARGV[2].nil? && ARGV[2].to_i > 0
              ARGV[2].to_i
            else
              0
            end

raise 'Folder does not exists!!!' unless Dir.exist?(folder)
unless name(folder)
  raise 'Folder name should contain karu or mada, puer or barb, please check!!!'
end

# remove previous bts folder stats
previous_stat_folder = './picnums'
if File.directory? previous_stat_folder
  puts "removing #{previous_stat_folder}..."
  FileUtils.rm_rf previous_stat_folder
end

##########  exit prematurally #########
# exit(0)

files = Dir.glob('**/*/tdump*')
unless contains_trajectories?(folder)
  raise 'Folder does not contain any trajectories, please check!!!'
end

# raise "File containing dates does not exists!!!" if !File.exists?(file)

tstat = TrajectoryStatD3Pm10sDatesPicNums.new folder, pm10_csv_file, threshold
# tstat = TrajectoryStat.new folder
# tstat.count
tstat.count_by_seasons_pm10s_dates

ntotal = 0

def pourcentage(gate_count, season_count)
  ((gate_count.to_f / season_count) * 100).round(2)
rescue ZeroDivisionError
  -9
end

File.open(File.basename(folder) + "_sup_#{threshold}" + '_stat.txt', 'w+') do |output_file|
  CSV.open(File.basename(folder) + "_sup_#{threshold}" + '_details.csv', 'w+') do |csv|
    output_file.write "***********#{name(folder)} @ #{level(folder)}*************\n"
    [tstat.ndjf, tstat.ma, tstat.mjja, tstat.so].each do |tstat|
      output_file.write ("season : #{tstat[:name]}, " \
          "count = #{tstat[:total]}" + "\n")
      %i[nwap swap neap sa north ind].each do |gate|
        ntotal +=  tstat[gate][:total]
        # puts ">nwap count = #{tstat[:nwap]}"
        sup_stats = DescriptiveStatistics::Stats.new(tstat[gate][:pm10s])

        output_file.write "> #{gate} count = #{tstat[gate][:total]}\n"
        output_file.write "> #{gate}/#{tstat[:name]} = #{pourcentage(tstat[gate][:total], tstat[:total])}%\n"
        if tstat[gate][:total] > 0
          output_file.write "> #{gate} pm10mean = #{tstat[gate][:pm10s].mean.round(2)}\n"
          output_file.write "> #{gate} min = #{sup_stats.min.round(2)}\n"
          output_file.write "> #{gate} max = #{sup_stats.max.round(2)}\n"
          output_file.write "> #{gate} std = #{tstat[gate][:pm10s].standard_deviation.round(2)}\n"
          output_file.write "> #{gate} median = #{tstat[gate][:pm10s].median.round(2)}\n"
          output_file.write "> #{gate} skewness = #{sup_stats.skewness.round(3)}\n"
          output_file.write "> #{gate} kurtosis = #{sup_stats.kurtosis.round(3)}\n"
        end

        dates_pm10s = [tstat[gate][:dates], tstat[gate][:pm10s], tstat[gate][:picnums]].transpose
        dates_pm10s.each do |date, pm10, picnum|
          csv << [picnum, date, pm10, gate.to_s]
        end
      end
    end
  end

  output_file.write "total de trajectoires traitées =#{ntotal}\n"
  output_file.write "total de trajectoires dans le dossier =#{tstat.files.length}\n"
  # output_file.write "total d3dates=#{tstat.length}\n"

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
  output_file.write '************************'
end

# Prepare data results [season, gate, date, pm10 ] to a csv file
# To a file
# CSV.open(File.basename(folder) +  "_sup_#{threshold}" + "_details.csv" ,"w+") do |csv|
#   [tstat.ndjf, tstat.ma, tstat.mjja, tstat.so].each do |tstat|
#        [:nwap, :swap, :neap, :sa, :north, :ind].each do |gate|
#            dates_pm10s = [tstat[gate][:dates], tstat[gate][:pm10s]].transpose
#            dates_pm10s.each do |date,pm10|
#                csv << [tstat[:name].to_s, gate.to_s, date, pm10]
#            end
#        end
#   end
# end
