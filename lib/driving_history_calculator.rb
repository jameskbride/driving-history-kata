require 'driving_record'
require 'record_parser'

class DrivingHistoryCalculator

  def initialize(input_records = [])
    @input_records = input_records
    @driving_records = Hash.new
    @input_records.each { |record|
      add_record(record)
    }
  end

  def add_record(record)
    record = RecordParser::parse(record)
    if !@driving_records[record.name]
      driving_record = DrivingRecord.new(record.name)
      driving_record.add_record(record)
      @driving_records[driving_record.name] = driving_record
    else
      @driving_records[record.name].add_record(record)
    end
  end

  def generate_report_lines()
    if !@input_records.empty?
      records = @driving_records.map {|key, value|
         value
      }.sort.map {|record|
        record.to_s
      }

      records
    else
      []
    end
  end
end