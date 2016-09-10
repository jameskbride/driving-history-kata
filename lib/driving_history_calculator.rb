class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle duplicate Drivers
      # TODO: Handle invalid command entries
      # TODO: Handle invalidly formatted commands
      driver_names = collect_drivers(lines)
      trips = collect_trips(lines)
      create_reportable_trips(driver_names, trips)
    end

    private

    RECORD_SPLIT_PATTERN = ' '
    COMMAND_DRIVER = 'Driver'
    COMMAND_TRIP = 'Trip'
    DRIVER_NAME_INDEX = 1
    TRIP_DISTANCE_INDEX = 4

    def collect_drivers(lines)
      driver_names = lines.select{ |line|
        line.start_with? COMMAND_DRIVER
      }.map{ |driver|
        driver_tokens = driver.split(RECORD_SPLIT_PATTERN)
        {driver_tokens[DRIVER_NAME_INDEX] => 0}
      }.reduce({}, :merge)

      driver_names
    end

    def collect_trips(lines)
      trips = lines.select{ |line|
        line.start_with? COMMAND_TRIP
      }.map {|trip|
        trip_tokens = trip.split(RECORD_SPLIT_PATTERN)
        {trip_tokens[DRIVER_NAME_INDEX] => trip_tokens[TRIP_DISTANCE_INDEX].to_f.round.to_i}
      }.reduce({}, :merge)

      trips
    end

    def create_reportable_trips(drivers, trips)
      reported_trips = drivers.merge(trips)
        .map {|key, value|
          "#{key}: #{value} miles"
        }

      reported_trips
    end
end
