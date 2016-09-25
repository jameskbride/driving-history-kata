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

  def calc_total_minutes
    @trips.map {|trip|
      minutes = trip.calc_minutes

      minutes == nil ? 0 : minutes
    }.reduce {|total, distance|
      total + distance
    }
  end

  def calc_speed
    normalized_minutes = calc_total_minutes / 60

    normalized_minutes > 0 ? (calc_total_distance / normalized_minutes).round.to_i : nil
  end

  def to_s
    total_distance = calc_total_distance
    average_speed = calc_speed
    if (average_speed)
      "#{@name}: #{total_distance.round.to_i} miles @ #{average_speed} mph"
    else
      "#{@name}: #{total_distance.round.to_i} miles"
    end
  end
end