#!/usr/bin/env ruby
require_relative 'trajectory_stat_d3'

def name folder
    if folder.match(/karu|mada/) then folder.match(/karu|mada/)[0]
    else nil
    end
end

def level folder
    if folder.match(/1500|2000/) then folder.match(/1500|2000/)[0]
    else nil
    end
end

raise "No folder provided!!!" if !ARGV[0]
folder = ARGV[0]

raise "No D3 file provided!!!" if !ARGV[1]
file = ARGV[1]


raise "Folder does not exists!!!" if !Dir.exists?(folder)
raise "Folder should contain karu or mada, please check!!!" if !name(folder)

raise "File does not exists!!!" if !File.exists?(file)

d3datesfile = File.expand_path file
d3dates = IO.readlines(d3datesfile).each {|date| date.chomp!}.uniq


tstat = TrajectoryStatD3.new folder, d3dates
tstat.count

puts "***********#{name(folder)} @ #{level(folder)}*************"
ntotal = 0

[tstat.ndjf, tstat.ma, tstat.mjja, tstat.so].each do |tstat|
    puts (tstat[:name].to_s + "\n")

    ntotal +=  tstat[:nwap]
    puts ">nwap count = #{tstat[:nwap]}" 

    ntotal +=  tstat[:swap]
    puts ">swap count =  #{tstat[:swap]}"

    ntotal +=  tstat[:neap]
    puts ">neap count = #{tstat[:neap]}"

    ntotal +=  tstat[:ind]
    puts ">ind count = #{tstat[:ind]}"

end 

    puts "total de trajectoires traitées =#{ntotal}"
    puts "total de trajectoires dans le dossier =#{tstat.files.length}"
    puts "total d3dates=#{d3dates.length}"
    
    puts "************************"
    puts "************************"
    tstat.gates.each do |gate|
        puts "gate name  = #{gate.name}"
        puts ">north limit = #{gate.north}"
        puts ">south limit = #{gate.south}"
        puts ">west limit = #{gate.west}"
        puts ">east limit = #{gate.east}"
        puts "\n"
    end
    puts "************************"
    puts "************************"
    

