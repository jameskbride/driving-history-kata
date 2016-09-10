require 'stringio'

describe DrivingHistoryCalculator do

    let(:calculator) { DrivingHistoryCalculator.new }

    it 'outputs entries for drivers with no record' do
      driving_records = [
        'Driver Dan',
        'Driver Steve'
      ]

      report_lines = calculator.calc(driving_records)

      expect(report_lines.length).to eq(2)
      expect(report_lines).to include('Dan: 0 miles')
      expect(report_lines).to include('Steve: 0 miles')
    end

    it 'calculates the distance for a single valid trip' do
      driving_records = [
        'Driver Dan',
        'Trip Dan 07:15 07:45 17.3'
      ]

      report_lines = calculator.calc(driving_records)

      expect(report_lines.length).to eq(1)
      expect(report_lines[0]).to start_with('Dan: 17 miles')
    end

    it 'calculates the speed for a single valid trip' do
      driving_records = [
        'Driver Dan',
        'Trip Dan 07:15 07:45 17.3'
      ]

      report_lines = calculator.calc(driving_records)

      expect(report_lines.length).to eq(1)
      expect(report_lines[0]).to eq('Dan: 17 miles @ 35 mph')
    end

    it 'outputs mixed entries including drivers with no trips' do
      driving_records = [
        'Driver Dan',
        'Trip Dan 07:15 07:45 17.3',
        'Driver Edward'
      ]

      report_lines = calculator.calc(driving_records)

      expect(report_lines.length).to eq(2)
      expect(report_lines[0]).to start_with('Dan: 17 miles')
      expect(report_lines[1]).to eq('Edward: 0 miles')
    end
end
