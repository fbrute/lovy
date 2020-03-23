# frozen_string_literal: true

require 'byebug'

class TrajectoryClassifier
  def initialize(gates, traj)
    # We expect first gate to be nwap, second swap
    @gates = gates
    @traj = traj

    if @traj.first.class != String
      raise 'data should be an array of strings, with each string containing lat and lon, space separated'
      end
  end

  def pathsaved
    idx = classify
    if idx == 0 then :nwap
    elsif idx == 1 then :swap
    elsif idx == 2 then :ind
    else :neap
    end
  end

  def path_v1
    @gates.each do |gate|
      # @gates.each{|g| puts g.inspect}
      # p "@@@@@@@@@@@@@@@@@@@@@@@@@"
      # p @traj.inspect
      if @traj.any? do |latlon|
           lat, lon = latlon.split ' '
           lat.to_f > gate.south &&
           lat.to_f < gate.north &&
           lon.to_f > gate.west &&
           lon.to_f < gate.east
         end then return gate.name
      end
    end # gates.each
    # index 2, greater than @gates.length
    :ind
  end

  def path_v2(gates)
    gates.each do |gate|
      # @gates.each{|g| puts g.inspect}
      # p "@@@@@@@@@@@@@@@@@@@@@@@@@"
      # p @traj.inspect
      if @traj.any? do |latlon|
           lat, lon = latlon.split ' '
           lat.to_f > gate.south &&
           lat.to_f < gate.north &&
           lon.to_f > gate.west &&
           lon.to_f < gate.east
         end then return gate.name
      end
    end # gates.each
    # index 2, greater than @gates.length
    :ind
  end

  def path_v3(gates)
    gates.each do |gate|
      # @gates.each{|g| puts g.inspect}
      # p "@@@@@@@@@@@@@@@@@@@@@@@@@"
      # p @traj.inspect
      puts @traj.reverse
      puts @traj.count
      if @traj.any? do |latlon|
           lat, lon = latlon.split ' '
           puts "#{lat},#{lon}"
           lat.to_f > gate.south &&
           lat.to_f < gate.north &&
           lon.to_f > gate.west &&
           lon.to_f < gate.east
         end then return gate.name
      end
    end # gates.each
    nil
  end

  def in_gate?(lat, lon, gate)
    if lat > gate.south &&
       lat < gate.north &&
       lon > gate.west &&
       lon < gate.east
        then true
    else
      false
    end
  end

  def path(gates)
    gates.each do |gate|
      # @gates.each{|g| puts g.inspect}
      # p "@@@@@@@@@@@@@@@@@@@@@@@@@"
      # p @traj.inspect
      # puts @traj.reverse
      # puts @traj.count
      @traj.reverse.each do |latlon|
        lat, lon = latlon.split ' '
        next unless in_gate? lat.to_f, lon.to_f, gate

        puts "gate.name = #{gate.name}"
        puts "lat_lon=(#{lat},#{lon})"
        return gate.name
      end
    end # gates.each
    nil
  end
end
