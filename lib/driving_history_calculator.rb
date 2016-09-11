class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle invalidly formatted commands
      drivers = collect_drivers(lines)
      trips = collect_trips(lines)
      default_trips = create_default_trips(drivers)
      reported_trips = create_reported_trips(trips)
      sorted_trips = sort_trips(default_trips.merge(reported_trips).values)
      create_reportable_trips(sorted_trips)
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
    MINIMUM_SPEED = 5
    MAXIMUM_SPEED = 100

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
        driver_name = driver_tokens[DRIVER_NAME_INDEX]
        trip_data = default_trip_data
        trip_data[:driver_name] = driver_name
        {driver_name => trip_data}
      }.reduce({}, :merge)
    end

    def create_reported_trips(trips)
      trips.map {|trip|
        trip_tokens = trip.split(RECORD_SPLIT_PATTERN)
        distance = trip_tokens[TRIP_DISTANCE_INDEX].to_f
        start_time = Time.parse(trip_tokens[START_TIME_INDEX])
        end_time = Time.parse(trip_tokens[END_TIME_INDEX])
        trip_minutes = calc_trip_minutes(start_time, end_time)
        normalized_trip_minutes = normalize_trip_minutes(trip_minutes)
        speed = normalized_trip_minutes > 0 ? calc_speed(normalized_trip_minutes, distance) : nil
        { trip_tokens[DRIVER_NAME_INDEX] => {:distance => distance,
                                             :trip_minutes => trip_minutes,
                                             :speed => speed }
        }
      }.reject {|trip|
        speed = trip[trip.keys[0]][:speed]
        speed == nil || speed < MINIMUM_SPEED || speed > MAXIMUM_SPEED
      }.reduce({}) {|trip_summaries,trip|
        driver_name = trip.keys[0]
        if (!trip_summaries[driver_name])
          trip_data = default_trip_data
          trip_data[:driver_name] = driver_name
          trip_summaries[driver_name] = trip_data
        end

        update_summary_distance(trip_summaries, trip, driver_name)
        update_summary_minutes(trip_summaries, trip, driver_name)
        update_summary_speed(trip_summaries, driver_name)

        trip_summaries
      }
    end

    def calc_trip_minutes(start_time, end_time)
      (end_time - start_time) / MINUTES_IN_AN_HOUR
    end

    def update_summary_distance(trip_summaries, trip, driver_name)
      current_distance = trip_summaries[driver_name][:distance]
      updated_distance = current_distance + trip[driver_name][:distance]
      trip_summaries[driver_name][:distance] = updated_distance
    end

    def update_summary_minutes(trip_summaries, trip, driver_name)
      current_trip_minutes = trip_summaries[driver_name][:trip_minutes]
      updated_trip_minutes = current_trip_minutes + trip[driver_name][:trip_minutes]
      trip_summaries[driver_name][:trip_minutes] = updated_trip_minutes
    end

    def update_summary_speed(trip_summaries, driver_name)
      normalized_trip_minutes = normalize_trip_minutes(trip_summaries[driver_name][:trip_minutes])
      speed = nil
      if (normalized_trip_minutes > 0)
        speed = calc_speed(normalized_trip_minutes, trip_summaries[driver_name][:distance]).round.to_i
      end
      trip_summaries[driver_name][:speed] = speed
    end

    def normalize_trip_minutes(trip_minutes)
      trip_minutes / MINUTES_IN_AN_HOUR
    end

    def calc_speed(normalized_trip_minutes, distance)
      (distance / normalized_trip_minutes)
    end

    def sort_trips(trips)
      trips.sort{|trip1,trip2| trip2[:distance] <=> trip1[:distance]}
    end

    def create_reportable_trips(driver_trips)
      reported_trips = driver_trips.map {|value|
          if (value[:speed])
            "#{value[:driver_name]}: #{value[:distance].round.to_i} miles @ #{value[:speed]} mph"
          else
            "#{value[:driver_name]}: #{value[:distance].round.to_i} miles"
          end
        }

      reported_trips
    end

    def default_trip_data
      {:distance => 0, :trip_minutes => 0}
    end
end
