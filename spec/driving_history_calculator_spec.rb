require 'stringio'

describe DrivingHistoryCalculator do

    it 'outputs an entry for a driver with no records' do
        driving_records = ['Driver Bob']
        calculator = DrivingHistoryCalculator.new

        report_lines = calculator.calc(driving_records)

        expect(report_lines.first).to eq('Bob: 0 miles')
    end

    it 'outputs entries for drivers with no record' do
      driving_records = [
        'Driver Dan',
        'Driver Steve'
      ]

      calculator = DrivingHistoryCalculator.new

      report_lines = calculator.calc(driving_records)

      expect(report_lines).to include('Dan: 0 miles')
      expect(report_lines).to include('Steve: 0 miles')
    end
end
