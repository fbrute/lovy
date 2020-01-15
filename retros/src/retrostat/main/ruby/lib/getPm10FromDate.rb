#!/usr/bin/env ruby

# Module that provides to functions to include in a class
# 1 : getPm10s takes a csv file and loads all couples date,pm10 in a Hash for later retrieval for example in trajectory stats
# 2 : getPm10, takes a date as a string and returns the pm10 if found

require 'csv'
require 'date'

module GetPm10

    def GetPm10.toDate strDate
        date3array = strDate.split('-')
        if Date.valid_date?(date3array[0].to_i, date3array[1].to_i, date3array[2].to_i)
            Date.new(date3array[0].to_i, date3array[1].to_i, date3array[2].to_i)
        else
            nil
        end
    end

    def GetPm10.getPm10s(pm10_file_path, threshold)

        raise 'No PM10 threshold' if threshold.nil?

        #pm10_file_path = "/Volumes/MODIS/trafin/it/sauvegardes/trafin/fouyol/recherche/lovy/data/pm10/pm10karu.csv"

        hash_pm10_by_dates = {} 

        CSV.foreach(File.expand_path pm10_file_path) do |row|
            strDate, strpm10 = row[0].split ';'
            pm10 = strpm10.to_f
            date = GetPm10.toDate strDate
            next if date.nil?
            next if pm10.nil?
            next if pm10 < threshold
            #puts "#{date},#{pm10}"
            hash_pm10_by_dates[date] = pm10
        end
        # return the hash of dates
        hash_pm10_by_dates
    end


    # Date with "yyyy-mm-dd"
    def GetPm10.getPm10(pm10s,strDate)
        pm10 = pm10s[GetPm10.toDate strDate]
    end
end