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
        {driver_tokens[DRIVER_NAME_INDEX] => {:distance => 0, :trip_minutes => 0}}
      }.reduce({}, :merge)

      driver_names
    end

    def collect_trips(lines)
      trips = lines.select{ |line|
        line.start_with? COMMAND_TRIP
      }.map {|trip|
        trip_tokens = trip.split(RECORD_SPLIT_PATTERN)

        distance = trip_tokens[TRIP_DISTANCE_INDEX].to_f

        start_time = Time.parse(trip_tokens[2])
        end_time = Time.parse(trip_tokens[3])
        trip_minutes = (end_time - start_time) / 60
        {
          trip_tokens[DRIVER_NAME_INDEX] => {:distance => distance, :trip_minutes => trip_minutes }
        }
      }.reduce({}, :merge)

      trips
    end

    def create_reportable_trips(drivers, trips)
      reported_trips = drivers.merge(trips)
        .map {|key, value|
          distance = value[:distance]
          normalized_trip_minutes = value[:trip_minutes] / 60
          speed = nil
          if (normalized_trip_minutes > 0)
            speed = (distance / normalized_trip_minutes).round.to_i
            "#{key}: #{distance.round.to_i} miles @ #{speed} mph"
          else
            "#{key}: #{distance.round.to_i} miles"
          end          
        }

      reported_trips
    end
end
