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

    def collect_drivers(lines)
      driver_names = lines.select{ |line|
        line.start_with? 'Driver'
      }.map{ |driver|
        driver_tokens = driver.split(' ')
        {driver_tokens[1] => 0}
      }.reduce({}, :merge)

      driver_names
    end

    def collect_trips(lines)
      trips = lines.select{ |line|
        line.start_with? 'Trip'
      }.map {|trip|
        trip_tokens = trip.split(' ')
        {trip_tokens[1] => trip_tokens[4].to_f.round.to_i}
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
