class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle duplicate Drivers
      # TODO: Handle invalid command entries
      # TODO: Handle invalidly formatted commands
      driver_names = lines.select{ |line|
        line.start_with? 'Driver'
      }.map{ |driver|
        driver_tokens = driver.split(' ')
        {driver_tokens[1] => 0}
      }.reduce({}, :merge)

      trips = lines.select{ |line|
        line.start_with? 'Trip'
      }.map {|trip|
        trip_tokens = trip.split(' ')
        {trip_tokens[1] => trip_tokens[4].to_f.round.to_i}
      }.reduce({}, :merge)

      reported_trips = driver_names.merge(trips)
        .map {|key, value|
          "#{key}: #{value} miles"
        }

      reported_trips
    end
end
