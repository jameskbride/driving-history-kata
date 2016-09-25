class Driver
  attr_reader :name, :distance

  def initialize(name)
    @name = name
    @distance = 0
  end

  def calc_minutes
    0
  end

  def calc_trip_speed
    0
  end
end