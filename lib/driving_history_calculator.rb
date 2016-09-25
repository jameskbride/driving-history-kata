require 'driving_record'
require 'record_parser'

class DrivingHistoryCalculator

  def initialize(input_records = [])
    @input_records = input_records
    @driving_records = Hash.new
    @input_records.each { |record|
      record = RecordParser::parse(record)
      driving_record = DrivingRecord.new(record.name)
      @driving_records[driving_record.name] = driving_record
    }
  end

  def calc()
    if !@input_records.empty?
      report_lines = []
      @driving_records.each { |key, value|
        report_lines << (value.to_s)
      }
      report_lines
    else
      []
    end
  end
end