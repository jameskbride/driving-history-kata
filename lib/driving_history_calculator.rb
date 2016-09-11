class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle duplicate Drivers
      # TODO: Handle invalid command entries
      # TODO: Handle invalidly formatted commands
      drivers = collect_drivers(lines)
      trips = collect_trips(lines)
      default_trips = create_default_trips(drivers)
      reported_trips = create_reported_trips(trips)
      create_reportable_trips(default_trips.merge(reported_trips))
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

    def collect_trips(lines)
      lines.select{ |line|
        line.start_with? COMMAND_TRIP
      }
    end

    def create_default_trips(drivers)
      drivers.map{ |driver|
        driver_tokens = driver.split(RECORD_SPLIT_PATTERN)
        {driver_tokens[DRIVER_NAME_INDEX] => default_trip_data}
      }.reduce({}, :merge)
    end

    def create_reported_trips(trips)
      trips.map {|trip|
        trip_tokens = trip.split(RECORD_SPLIT_PATTERN)
        distance = trip_tokens[TRIP_DISTANCE_INDEX].to_f
        trip_minutes = calc_trip_minutes(trip_tokens)

        { trip_tokens[DRIVER_NAME_INDEX] => {:distance => distance, :trip_minutes => trip_minutes } }
      }.reduce({}) {|trip_summaries,trip|
        driver_name = trip.keys[0]
        if (!trip_summaries[driver_name])
          trip_summaries[driver_name] = default_trip_data
        end

        update_summary_distance(trip_summaries, trip, driver_name)
        updated_summary_minutes(trip_summaries, trip, driver_name)
        update_summary_speed(trip_summaries, trip, driver_name)

        trip_summaries
      }
    end

    def calc_trip_minutes(trip_tokens)
      start_time = Time.parse(trip_tokens[START_TIME_INDEX])
      end_time = Time.parse(trip_tokens[END_TIME_INDEX])
      trip_minutes = (end_time - start_time) / MINUTES_IN_AN_HOUR
    end

    def update_summary_distance(trip_summaries, trip, driver_name)
      current_distance = trip_summaries[driver_name][:distance]
      updated_distance = current_distance + trip[driver_name][:distance]
      trip_summaries[driver_name][:distance] = updated_distance
    end

    def updated_summary_minutes(trip_summaries, trip, driver_name)
      current_trip_minutes = trip_summaries[driver_name][:trip_minutes]
      updated_trip_minutes = current_trip_minutes + trip[driver_name][:trip_minutes]
      trip_summaries[driver_name][:trip_minutes] = updated_trip_minutes
    end

    def update_summary_speed(trip_summaries, trip, driver_name)
      normalized_trip_minutes = trip_summaries[driver_name][:trip_minutes] / MINUTES_IN_AN_HOUR
      speed = nil
      if (normalized_trip_minutes > 0)
        speed = (trip_summaries[driver_name][:distance] / normalized_trip_minutes).round.to_i
      end
      trip_summaries[driver_name][:speed] = speed
    end

    def create_reportable_trips(driver_trips)
      reported_trips = driver_trips.map {|key, value|
          if (value[:speed])
            "#{key}: #{value[:distance].round.to_i} miles @ #{value[:speed]} mph"
          else
            "#{key}: #{value[:distance].round.to_i} miles"
          end
        }

      reported_trips
    end

    def default_trip_data
      {:distance => 0, :trip_minutes => 0}
    end
end
