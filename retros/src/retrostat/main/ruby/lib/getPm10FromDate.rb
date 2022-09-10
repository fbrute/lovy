#!/usr/bin/env ruby
# frozen_string_literal: true

# Module that provides to functions to include in a class
# 1 : getPm10s takes a csv file and loads all couples date,pm10 in a Hash for later retrieval for example in trajectory stats
# 2 : getPm10, takes a date as a string and returns the pm10 if found

require 'csv'
require 'date'

module GetPm10
  def self.toDate(strDate)
    date3array = strDate.split('-')
    if Date.valid_date?(date3array[0].to_i, date3array[1].to_i, date3array[2].to_i)
      Date.new(date3array[0].to_i, date3array[1].to_i, date3array[2].to_i)
    end
  end

  def self.getPicNums(pm10_file_path, threshold)
    raise 'No PM10 threshold' if threshold.nil?

    # pm10_file_path = "/Volumes/MODIS/trafin/it/sauvegardes/trafin/fouyol/recherche/lovy/data/pm10/pm10karu.csv"

    hash_pm10_by_dates = {}

    CSV.foreach(File.expand_path(pm10_file_path)) do |row|
      strDate, strpm10, pic_num = row[0].split ';'
      raise "No picnum available in csv file #{pm10_file_path}!" if pic_num.nil?

      pm10 = strpm10.to_f
      date = GetPm10.toDate strDate
      next if date.nil?
      next if pm10.nil?
      next if pic_num.nil?
      next if pm10 < threshold

      # puts "#{date},#{pm10}"
      hash_pm10_by_dates[date] = pic_num
    end
    # return the hash of dates
    hash_pm10_by_dates
  end

  def self.getPm10sSupInf(pm10_file_path, operator, threshold)
    raise 'No PM10 threshold' if threshold.nil?

    # pm10_file_path = "/Volumes/MODIS/trafin/it/sauvegardes/trafin/fouyol/recherche/lovy/data/pm10/pm10karu.csv"

    hash_pm10_by_dates = {}
    #CSV.foreach(File.expand_path(pm10_file_path)) do |row|
    CSV.foreach(pm10_file_path) do |row|
      str_date, strpm10 = row[0].split ';'
      pm10 = strpm10.to_f
      date = GetPm10.toDate str_date
      next if date.nil?
      next if pm10.nil?      

      #next if pm10 < threshold
      # now the threshold can be a roof!!! (april 2022)
      # operator can be :>, :>=, :<= or :<
      next if !eval("#{pm10} #{operator} #{threshold}")

      # puts "#{date},#{pm10}"
      hash_pm10_by_dates[date] = pm10
    end
    # return the hash of dates
    hash_pm10_by_dates
  end

  def self.getPm10s(pm10_file_path, threshold)
    raise 'No PM10 threshold' if threshold.nil?

    # pm10_file_path = "/Volumes/MODIS/trafin/it/sauvegardes/trafin/fouyol/recherche/lovy/data/pm10/pm10karu.csv"

    hash_pm10_by_dates = {}

    CSV.foreach(File.expand_path(pm10_file_path)) do |row|
      str_date, strpm10 = row[0].split ';'
      pm10 = strpm10.to_f
      date = GetPm10.toDate str_date
      next if date.nil?
      next if pm10.nil?
      next if pm10 < threshold

      # puts "#{date},#{pm10}"
      hash_pm10_by_dates[date] = pm10
    end
    # return the hash of dates
    hash_pm10_by_dates
  end


  # Date with "yyyy-mm-dd"
  def self.getPm10(pm10s, strDate)
    pm10 = pm10s[GetPm10.toDate strDate]
  end
end
