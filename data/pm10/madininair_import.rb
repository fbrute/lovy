#!/usr/bin/env ruby
datetimes = []
pm10 = []

File.open("export_mesure_fixe.csv").each_with_index do |line,idx|
    values = line.split ";"
    #values = values.slice(1,values.length) 
    # remove first element
    values.shift
    puts values.length

    datetimes = values if (idx == 1)
    pm10 = values if (idx == 2)
end

lines = []
datetimes.each_index do |idx| 
   lines << datetimes[idx].gsub(/"/,'') + ";" + pm10[idx].to_s
end

File.open("madininair.csv","a") do |file|
    lines.each do |line|
        file.puts line
    end
end

#puts datetimes.slice(0,10)
#puts pm10.length
#puts lines.slice(0,10)
puts datetimes.last
puts pm10.last

puts lines.first
puts lines.first.length

puts lines.last
puts lines.last.length
