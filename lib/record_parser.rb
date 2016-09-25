require 'driver'

class RecordParser

  def self.parse(record)
    record_parts = record.split(' ')
    Driver.new(record_parts[1])
  end
end