require 'driver'

class RecordParser

  COMMAND_DRIVER = 'Driver'
  COMMAND_TRIP = 'Trip'
  SPLITTER_REGEX = ' '

  COMMAND_TYPE_INDEX = 0
  NAME_INDEX = 1
  START_TIME_INDEX = 2
  END_TIME_INDEX = 3
  DISTANCE_INDEX = 4

  def self.parse(record)
    record_parts = record.split(SPLITTER_REGEX)
    if can_parse_driver?(record_parts)
      parse_driver(record_parts)
    elsif can_parse_trip?(record_parts)
      parse_trip(record_parts)
    end
  end

  def self.can_parse_driver?(record_parts)
    record_parts[COMMAND_TYPE_INDEX] == COMMAND_DRIVER
  end

  def self.parse_driver(record_parts)
    Driver.new(record_parts[NAME_INDEX])
  end

  def self.can_parse_trip?(record_parts)
    record_parts[COMMAND_TYPE_INDEX] == COMMAND_TRIP
  end

  def self.parse_trip(record_parts)
    Trip.new(record_parts[NAME_INDEX], record_parts[DISTANCE_INDEX].to_f, record_parts[START_TIME_INDEX], record_parts[END_TIME_INDEX])
  end
end