require 'stringio'

describe DrivingHistoryCalculator do

    it 'outputs an entry for a driver with no records' do
        driving_records = ['Driver Bob']
        calculator = DrivingHistoryCalculator.new
        
        report_lines = calculator.calc(driving_records)
        expect(report_lines.first).to eq('Bob: 0 miles')
    end
end
