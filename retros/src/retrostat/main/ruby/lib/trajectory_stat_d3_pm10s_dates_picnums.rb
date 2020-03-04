# frozen_string_literal: true

require_relative 'trajectory_stat_d3_pm10s_dates'
require_relative 'getPm10FromDate'
require 'fileutils'

class TrajectoryStatD3Pm10sDatesPicNums < TrajectoryStatD3Pm10sDates
  def initialize(folder, pm10sFile, threshold)
    super(folder, pm10sFile, threshold)

    @seasons = []

    @ndjf = {   neap: { total: 0, dates: [], pm10s: [], picnums: [] },
                nwap: { total: 0, dates: [], pm10s: [], picnums: [] },
                swap: { total: 0, dates: [], pm10s: [], picnums: [] },
                ind: { total: 0, dates: [], pm10s: [], picnums: [] },
                sa: { total: 0, dates: [], pm10s: [], picnums: [] },
                north: { total: 0, dates: [], pm10s: [], picnums: [] },
                name: :ndjf,
                months: [11, 12, 1, 2],
                total: 0 }

    @ma = {     neap: { total: 0, dates: [], pm10s: [], picnums: [] },
                nwap: { total: 0, dates: [], pm10s: [], picnums: [] },
                swap: { total: 0, dates: [], pm10s: [], picnums: [] },
                ind: { total: 0, dates: [], pm10s: [], picnums: [] },
                sa: { total: 0, dates: [], pm10s: [], picnums: [] },
                north: { total: 0, dates: [], pm10s: [], picnums: [] },
                name: :ma,
                months: [3, 4],
                total: 0 }

    @mjja = {   neap: { total: 0, dates: [], pm10s: [], picnums: [] },
                nwap: { total: 0, dates: [], pm10s: [], picnums: [] },
                swap: { total: 0, dates: [], pm10s: [], picnums: [] },
                ind: { total: 0, dates: [], pm10s: [], picnums: [] },
                sa: { total: 0, dates: [], pm10s: [], picnums: [] },
                north: { total: 0, dates: [], pm10s: [], picnums: [] },
                name: :mjja,
                months: [5, 6, 7, 8],
                total: 0 }

    @so = {     neap: { total: 0, dates: [], pm10s: [], picnums: [] },
                nwap: { total: 0, dates: [], pm10s: [], picnums: [] },
                swap: { total: 0, dates: [], pm10s: [], picnums: [] },
                ind: { total: 0, dates: [], pm10s: [], picnums: [] },
                sa: { total: 0, dates: [], pm10s: [], picnums: [] },
                north: { total: 0, dates: [], pm10s: [], picnums: [] },
                name: :so,
                months: [9, 10],
                total: 0 }

    [@ndjf, @ma, @mjja, @so].each { |season| @seasons << season }
  end

  def count_retros(files, gates, pm10s, pm10s_picnums)
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
      pic_num = pm10s_picnums[GetPm10.toDate date]

      next if pm10.nil?
      next if pm10 < @threshold

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
          season[path][:picnums] << pic_num
          target_directory = 'picnums'
          unless File.directory? target_directory
            FileUtils.mkdir_p target_directory
          end
          'shp prj shx dbf'.split.each do |extension|
            sourcefile = File.join(date.slice(0..3), + 'gis_shape' + date6(file) + '.' + extension)
            # sourcefile = 'gis_shape' + date6(file) + '.' + extension)
            destfile = date6(file) + "_#{path}" + "_#{pic_num}" + '.' + extension
            # puts sourcefile
            FileUtils.cp sourcefile, File.join(target_directory, destfile)
          end
          sourcefile = File.join(date.slice(0..3), 'plot' + date6(file) + '.ps')
          destfile = 'plot' + date6(file) + '.ps'
          FileUtils.cp sourcefile, File.join(target_directory, destfile)
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

  def count_by_seasons_pm10s_dates
    # Version of counting with pm10s and dates
    # get pm10s values as a hash with date as key
    pm10sValues = GetPm10.getPm10s(@pm10s, @threshold)
    puts pm10sValues
    pm10sPicNums = GetPm10.getPicNums(@pm10s, @threshold)
    puts pm10sPicNums
    # First counting nwap and swap retros
    remaining_files = count_retros @files, [@nwap, @swap], pm10sValues, pm10sPicNums
    # Then count neap and leave the others to indetermined
    remaining_files =  count_retros remaining_files, [@neap], pm10sValues, pm10sPicNums
    remaining_files =  count_retros remaining_files, [@sa], pm10sValues, pm10sPicNums
    remaining_files =  count_retros remaining_files, [@north], pm10sValues, pm10sPicNums
    remaining_files =  count_retros remaining_files, [@ind], pm10sValues, pm10sPicNums
  end
end