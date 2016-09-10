class DrivingHistoryCalculator

    def calc(lines)
      # TODO: Handle duplicate Drivers
      # TODO: Handle invalid command entries
      # TODO: Handle invalidly formatted commands
      driver_names = lines.collect do|line|
        line.split(' ')[1] + ': 0 miles'
      end
      
      driver_names
    end
end
