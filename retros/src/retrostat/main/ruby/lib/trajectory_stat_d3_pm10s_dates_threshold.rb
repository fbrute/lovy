# frozen_string_literal: true

require_relative 'trajectory_stat'
require_relative 'getPm10FromDate'
require 'fileutils'

class TrajectoryStatD3Pm10sDatesWithThreshold < TrajectoryStat
  attr_accessor :gate_stats
  attr_accessor :dates_stats
  attr_accessor :pm10s_stats

  include GetPm10
  include FileUtils


  def initialize(folder, pm10sFile, operator, threshold)
    super(folder)


    @operator = operator
    @pm10s = pm10sFile
    @threshold = threshold

    @seasons = []

    # @ndjf = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ndjf , months: [11,12,1,2] }
    # @ma   = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ma   , months: [3,4] }
    # @mjja = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :mjja , months: [5,6,7,8] }
    # @so   = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :so   , months: [9,10] }

    @ndjf = {   neap: { total: 0, dates: [], pm10s: [] },
                nwap: { total: 0, dates: [], pm10s: [] },
                swap: { total: 0, dates: [], pm10s: [] },
                ind: { total: 0, dates: [], pm10s: [] },
                sa: { total: 0, dates: [], pm10s: [] },
                north: { total: 0, dates: [], pm10s: [] },
                name: :ndjf,
                months: [11, 12, 1, 2],
                total: 0 }

    @ma = {     neap: { total: 0, dates: [], pm10s: [] },
                nwap: { total: 0, dates: [], pm10s: [] },
                swap: { total: 0, dates: [], pm10s: [] },
                ind: { total: 0, dates: [], pm10s: [] },
                sa: { total: 0, dates: [], pm10s: [] },
                north: { total: 0, dates: [], pm10s: [] },
                name: :ma,
                months: [3, 4],
                total: 0 }

    @mjja = {   neap: { total: 0, dates: [], pm10s: [] },
                nwap: { total: 0, dates: [], pm10s: [] },
                swap: { total: 0, dates: [], pm10s: [] },
                ind: { total: 0, dates: [], pm10s: [] },
                sa: { total: 0, dates: [], pm10s: [] },
                north: { total: 0, dates: [], pm10s: [] },
                name: :mjja,
                months: [5, 6, 7, 8],
                total: 0 }

    @so = {     neap: { total: 0, dates: [], pm10s: [] },
                nwap: { total: 0, dates: [], pm10s: [] },
                swap: { total: 0, dates: [], pm10s: [] },
                ind: { total: 0, dates: [], pm10s: [] },
                sa: { total: 0, dates: [], pm10s: [] },
                north: { total: 0, dates: [], pm10s: [] },
                name: :so,
                months: [9, 10],
                total: 0 }

    [@ndjf, @ma, @mjja, @so].each { |season| @seasons << season }

    # stats at gate level without seasons (april 2022)
    @gate_stats = { neap: 0, nwap: 0, swap: 0, ind: 0,sa: 0,north: 0 }
    @dates_stats = { neap: [], nwap: [], swap: [], ind: [],sa: [],north: [] }
    @pm10s_stats = { neap: [], nwap: [], swap: [], ind: [],sa: [],north: [] }
  end

  def date6(file)
    date = file.match(/(\d{2}\d{2}\d{2})/)[0]
  end

  def count_retros_by_gates(files, gates, pm10s)
    # puts "length of files to be treated = #{files.length}"
    # to keep track of treated dates
    remaining_files = []
    puts "nfiles = #{files.length}"
    files.each do |file|
      trajectory = traj(file)
      trajclass = TrajectoryClassifier.new gates, trajectory
      month = month file
      date = date file
      pm10 = pm10s[GetPm10.toDate date]

      next if pm10.nil?

      path = trajclass.path gates
      if gates.any? { |gate| gate.name == path }
        @gate_stats[path] += 1
        puts "date=#{date}"
        @dates_stats[path] << date
        @pm10s_stats[path] << pm10
        next
      else
        # keep track of treated dates
        remaining_files << file
      end
    end
    # puts "length of remaining_files = #{remaining_files.length}"
    remaining_files
  end

  def count_retros(files, gates, pm10s)
    # puts "length of files to be treated = #{files.length}"
    # to keep track of treated dates
    remaining_files = []
    puts "nfiles = #{files.length}"
    files.each do |file|
      trajectory = traj(file)
      trajclass = TrajectoryClassifier.new gates, trajectory
      month = month file
      date = date file
      pm10 = pm10s[GetPm10.toDate date]

      next if pm10.nil?
      # must be useless because of count_by_seasons::getPm10sSupInf() filtering
      #next if !eval("#{pm10} #{@operator} #{@threshold}")

      # puts "date = #{date}"
      # puts "pm10 = #{pm10}"

      @seasons.each do |season|
        next unless season[:months].include? month

        path = trajclass.path gates
        if gates.any? { |gate| gate.name == path }
          season[:total] += 1
          season[path][:total] += 1
          season[path][:dates] << date
          season[path][:pm10s] << pm10
          target_directory = File.join season[:name].to_s, path.to_s
          unless File.directory? target_directory
            FileUtils.mkdir_p target_directory
          end
          'shp prj shx dbf'.split.each do |extension|
            sourcefile = File.join(date.slice(0..3), + 'gis_shape' + date6(file) + '.' + extension)
            destfile = 'gis_shape' + date6(file) + "_#{path}_" + '.' + extension
            # puts sourcefile
            FileUtils.cp sourcefile, File.join(target_directory, destfile)
          end
          next
        else
          # keep track of treated dates
          remaining_files << file
        end
      end
    end
    # puts "length of remaining_files = #{remaining_files.length}"
    remaining_files
  end

  def count_by_gates_with_pm10s_and_dates
    # Version of counting with pm10s and dates
    # get pm10s values as a hash with date as key
    # getPm10sSupInf filter according to operator and threshold/roof
    # April 2022
    pm10sValues = GetPm10.getPm10sSupInf(@pm10s, @operator, @threshold)
    # First counting nwap and swap retros
    remaining_files = count_retros @files, [@nwap, @swap], pm10sValues
    # Then count neap and leave the others to indetermined
    remaining_files =  count_retros_by_gates remaining_files, [@neap], pm10sValues
    remaining_files =  count_retros_by_gates remaining_files, [@sa], pm10sValues
    remaining_files =  count_retros_by_gates remaining_files, [@north], pm10sValues
    remaining_files =  count_retros_by_gates remaining_files, [@ind], pm10sValues
  end

  def count_by_seasons_pm10s_dates
    # Version of counting with pm10s and dates
    # get pm10s values as a hash with date as key
    pm10sValues = GetPm10.getPm10s(@pm10s, @threshold)
    # First counting nwap and swap retros
    remaining_files = count_retros @files, [@nwap, @swap], pm10sValues
    # Then count neap and leave the others to indetermined
    remaining_files =  count_retros remaining_files, [@neap], pm10sValues
    remaining_files =  count_retros remaining_files, [@sa], pm10sValues
    remaining_files =  count_retros remaining_files, [@north], pm10sValues
    remaining_files =  count_retros remaining_files, [@ind], pm10sValues
  end
end
