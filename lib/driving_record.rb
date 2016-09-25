class DrivingRecord

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "#{@name}: 0 miles"
  end
end