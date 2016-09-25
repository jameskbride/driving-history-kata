require_relative 'driver'
require_relative 'driving_calculations'
require 'time'

class Trip < Driver
  include DrivingCalculations

  attr_reader :distance, :start_time, :end_time

  def initialize(name, distance=0, start_time=nil, end_time=nil)
    super(name)
    @distance = distance.to_f
    @start_time = start_time
    @end_time = end_time
  end

  def calc_minutes
    (Time::parse(@end_time) - Time::parse(@start_time)) / 60
  end

  def calc_trip_speed
    minutes = calc_minutes
    minutes > 0 ? calc_speed(minutes, @distance) : 0
  end
end