require 'driver'

class RecordParser

  COMMAND_DRIVER = 'Driver'
  COMMAND_TRIP = 'Trip'
  SPLITTER_REGEX = ' '

  COMMAND_TYPE_INDEX = 0
  NAME_INDEX = 1
  DISTANCE_INDEX = 4

  def self.parse(record)
    record_parts = record.split(SPLITTER_REGEX)
    if record_parts[COMMAND_TYPE_INDEX] == COMMAND_DRIVER
      Driver.new(record_parts[NAME_INDEX])
    elsif record_parts[COMMAND_TYPE_INDEX] == COMMAND_TRIP
      Trip.new(record_parts[NAME_INDEX], record_parts[DISTANCE_INDEX].to_f)
    end
  end
end