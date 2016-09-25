class DrivingRecord

  attr_reader :name

  def initialize(name)
    @name = name
    @trips = []
  end

  def add_record(record)
    if record.distance != nil
      @trips << record
    end
  end

  def to_s
    total_distance = @trips.map {|trip|
      trip.distance
    }.reduce {|total, distance| total + distance}
    "#{@name}: #{total_distance.round.to_i} miles"
  end
end