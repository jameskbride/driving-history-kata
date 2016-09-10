require 'stringio'

describe DrivingHistoryCalculator do

    let(:calculator) { DrivingHistoryCalculator.new }

    it 'outputs entries for drivers with no record' do
      driving_records = [
        'Driver Dan',
        'Driver Steve'
      ]

      report_lines = calculator.calc(driving_records)

      expect(report_lines).to include('Dan: 0 miles')
      expect(report_lines).to include('Steve: 0 miles')
    end
end
