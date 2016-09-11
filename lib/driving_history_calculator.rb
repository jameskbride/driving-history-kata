class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle duplicate Drivers
      # TODO: Handle invalid command entries
      # TODO: Handle invalidly formatted commands
      drivers = collect_drivers(lines)
      default_driver_trips = create_default_trips(drivers)
      trips = collect_reported_trips(lines)
      create_reportable_trips(default_driver_trips.merge(trips))
    end

    private

    RECORD_SPLIT_PATTERN = ' '
    COMMAND_DRIVER = 'Driver'
    COMMAND_TRIP = 'Trip'
    DRIVER_NAME_INDEX = 1
    START_TIME_INDEX = 2
    END_TIME_INDEX = 3
    TRIP_DISTANCE_INDEX = 4
    MINUTES_IN_AN_HOUR = 60

    def collect_drivers(lines)
      lines.select{ |line|
        line.start_with? COMMAND_DRIVER
      }
    end

    def create_default_trips(drivers)
      drivers.map{ |driver|
        driver_tokens = driver.split(RECORD_SPLIT_PATTERN)
        {driver_tokens[DRIVER_NAME_INDEX] => default_trip_data}
      }.reduce({}, :merge)
    end

    def collect_reported_trips(lines)
      trips = lines.select{ |line|
        line.start_with? COMMAND_TRIP
      }.map {|trip|
        trip_tokens = trip.split(RECORD_SPLIT_PATTERN)
        distance = trip_tokens[TRIP_DISTANCE_INDEX].to_f
        trip_minutes = calc_trip_minutes(trip_tokens)

        { trip_tokens[DRIVER_NAME_INDEX] => {:distance => distance, :trip_minutes => trip_minutes } }
      }.reduce({}) {|trip_summaries,trip|
        driver_name = trip.keys[0]
        if (!trip_summaries[driver_name])
          trip_summaries[driver_name] = default_trip_data
        end
        current_distance = trip_summaries[driver_name][:distance]
        trip_summaries[driver_name][:distance] = current_distance + trip[driver_name][:distance]

        current_trip_minutes = trip_summaries[driver_name][:trip_minutes]
        trip_summaries[driver_name][:trip_minutes] = current_trip_minutes + trip[driver_name][:trip_minutes]

        trip_summaries
      }

      trips
    end

    def default_trip_data
      {:distance => 0, :trip_minutes => 0}
    end

    def calc_trip_minutes(trip_tokens)
      start_time = Time.parse(trip_tokens[START_TIME_INDEX])
      end_time = Time.parse(trip_tokens[END_TIME_INDEX])
      trip_minutes = (end_time - start_time) / MINUTES_IN_AN_HOUR
    end

    def create_reportable_trips(driver_trips)
      reported_trips = driver_trips.map {|key, value|
          distance = value[:distance]
          normalized_trip_minutes = value[:trip_minutes] / MINUTES_IN_AN_HOUR

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
