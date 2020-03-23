# frozen_string_literal: true

require_relative 'gate'
require_relative 'trajectory_classifier'

class TrajectoryStat
  attr_reader :folder, :ndjf, :ma, :mjja, :so, :files, :gates, :seasons, :nwap, :swap, :neap

  def initialize(folder)
    @folder = File.expand_path(folder)

    @gates = []
    @gates << @nwap = Gate.new(:nwap, 35, -16, 10, -20)
    @gates << @swap = Gate.new(:swap, 10, -16, 0, -20)
    @gates << @neap = Gate.new(:neap, 35, -20, 20, -50)
    @gates << @sa = Gate.new(:sa, 10, -30,   0, -50)
    @gates << @north = Gate.new(:north, 30,  -50, 20, -60)
    # Arbitrary values for ind gate not overlaying nwap, swap or neap
    @gates << @ind = Gate.new(:ind, 90, 80, 80, 70)

    @seasons = []

    @ndjf = { neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ndjf, months: [11, 12, 1, 2] }
    @ma   = { neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ma, months: [3, 4] }
    @mjja = { neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :mjja, months: [5, 6, 7, 8] }
    @so   = { neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :so, months: [9, 10] }

    [@ndjf, @ma, @mjja, @so].each { |season| @seasons << season }

    Dir.chdir(@folder)
    # Needs the folder to be flattened
    # @files = Dir.glob("tdump*.txt")
    #
    # No need to flatten the folder
    @files = Dir.glob('**/*/tdump*')
    puts "@files.length = #{@files.length}"
    # if folder is flattened
    @files = Dir.glob('*tdump*') if @files.empty?
  end

  def traj(file)
    aresults = []
    `awk '/12/ {print $10, $11;}' #{file}`.split("\n").each .reject { |latlon| latlon == ' ' }
                                          .each { |latlon| aresults << latlon }
    aresults
  end

  def date(file)
    date = file.match(/(\d{2}\d{2}\d{2})/)[0]
    date.gsub(/(\d{2})(\d{2})(\d{2})/, '20\1-\2-\3')
  end

  def month(file)
    (file.match(/(\d{2})(\d{2})(\d{2})/)[2]).to_i
  end

  def count_retros(files, gates)
    # puts "length of files to be treated = #{files.length}"
    # to keep track of treated dates
    remaining_files = []
    files.each do |file|
      trajectory = traj(file)
      trajclass = TrajectoryClassifier.new gates, trajectory
      month = month file
      @seasons.each do |season|
        next unless season[:months].include? month

        path = trajclass.path gates
        if gates.any? { |gate| gate.name == path }
          season[path] += 1
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

  def count
    # Version 2 of counting
    # First counting nwap and swap retros
    remaining_files = count_retros @files, [@nwap, @swap]
    # Then count neap and leave the others to indetermined
    remaining_files =  count_retros remaining_files, [@neap]
    remaining_files =  count_retros remaining_files, [@ind]
  end

  def count_by_seasons_v3
    # Version 3 of counting
    # First counting nwap and swap retros
    remaining_files = count_retros @files, [@nwap, @swap]
    # Then count neap and leave the others to indetermined
    remaining_files =  count_retros remaining_files, [@neap]
    remaining_files =  count_retros remaining_files, [@sa]
    remaining_files =  count_retros remaining_files, [@north]
    remaining_files =  count_retros remaining_files, [@ind]
  end

  def count_v1
    @files.each do |file|
      trajectory = traj(file)
      trajclass = TrajectoryClassifier.new @gates, trajectory

      if [11, 12, 1, 2].include? month(file)
        if trajclass.path == :neap then @ndjf[:neap] += 1
        elsif
            trajclass.path == :nwap then @ndjf[:nwap] += 1
        elsif
            trajclass.path == :swap then @ndjf[:swap] += 1
        elsif
            trajclass.path == :ind then  @ndjf[:ind] += 1
        end
      end

      if [3, 4].include? month(file)
        if trajclass.path == :neap then @ma[:neap] += 1
        elsif
            trajclass.path == :nwap then @ma[:nwap] += 1
        elsif
            trajclass.path == :swap then @ma[:swap] += 1
        elsif
            trajclass.path == :ind then  @ma[:ind] += 1

        end
      end

      if [5, 6, 7, 8].include? month(file)
        @mjja[:neap] += 1 if trajclass.path == :neap
        @mjja[:nwap] += 1  if trajclass.path == :nwap
        @mjja[:swap] += 1  if trajclass.path == :swap
        @mjja[:ind] += 1 if trajclass.path == :ind
      end

      if [9, 10].include? month(file)
        if trajclass.path == :neap then @so[:neap] += 1
        elsif
            trajclass.path == :nwap then @so[:nwap] += 1
        elsif
            trajclass.path == :swap then @so[:swap] += 1
        elsif
            trajclass.path == :ind then  @so[:ind] += 1
        end
      end
    end
  end
end
