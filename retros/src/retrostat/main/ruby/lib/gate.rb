# frozen_string_literal: true

class Gate
  include Enumerable

  attr_reader :name, :north, :east, :south, :west, :heigth, :width

  def initialize(name, north, east, south, west)
    @name = name
    @north = north
    @east = east
    @south = south
    @west = west
    @height = @north - @south
    @width = @east - @west

    @routes = %i[neap swap nwap sa north ind west]

    raise 'the gate should have a name!!!' if @name.nil?

    unless @routes.include? @name
      raise 'the names are restricted to :neap, :swap,  :nwap, , :sa, :north or :ind!!!'
      end

    raise 'bad north limit for the gate!!!' if @north < -90 || @north > 90

    raise 'bad east limit for the gate!!!' if @east < -180 || @east > 180

    raise 'bad south limit for the gate!!!' if @south < -90 || @south > 90

    raise 'bad west limit for the gate!!!' if @west < -180 || @west > 180

    raise "north limit should be higher than south's!!!" if @north <= @south

    raise "east limit should be right of west's" if @east <= @west

    raise 'width should be 1 degree minimum!!!' if @width < 1

    raise 'height should be 1 degree minimum!!!' if @height < 1
  end
end
