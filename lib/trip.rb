require 'driver'

class Trip < Driver

  attr_reader :distance
  def initialize(name, distance=0)
    super(name)
    @distance = distance.to_f
  end
end