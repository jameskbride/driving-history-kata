class DrivingRecord
  include Comparable

  attr_reader :name

  def initialize(name)
    @name = name
    @trips = []
  end

  def <=>(other_driving_record)
    other_driving_record.calc_total_distance <=> calc_total_distance
  end

  def add_record(record)
    if record.distance != nil
      @trips << record
    end
  end

  def calc_total_distance
    @trips.map {|trip|
      trip.distance
    }.reduce {|total, distance|
      total + distance
    }
  end

  def to_s
    total_distance = calc_total_distance
    "#{@name}: #{total_distance.round.to_i} miles"
  end
end