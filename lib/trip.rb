require 'driver'
require 'time'

class Trip < Driver

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
end