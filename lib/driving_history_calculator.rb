require 'driving_record'

class DrivingHistoryCalculator



  def initialize(driving_records = [])
    @driving_records = driving_records
  end

  def calc()
    if !@driving_records.empty?
      [DrivingRecord.new.to_s]
    else
      []
    end
  end
end