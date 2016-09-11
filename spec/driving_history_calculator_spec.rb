require 'stringio'

describe DrivingHistoryCalculator do

    let(:calculator) { DrivingHistoryCalculator.new }

    describe 'When only Driver entries are found' do
      it 'outputs short entries' do
        driving_records = [
          'Driver Dan',
          'Driver Steve'
        ]

        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(2)
        expect(report_lines).to include('Dan: 0 miles')
        expect(report_lines).to include('Steve: 0 miles')
      end
    end

    describe 'When there is a single driver with a single trip' do
      let(:driving_records) {driving_records = [
        'Driver Dan',
        'Trip Dan 07:15 07:45 17.3'
      ]}

      it 'calculates the distance' do
        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to start_with('Dan: 17 miles')
      end

      it 'calculates the speed' do
        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to eq('Dan: 17 miles @ 35 mph')
      end
    end

    describe 'When there are multiple entries for a single driver' do
      it 'calculates the total distance' do
        driving_records = [
          'Driver Dan',
          'Trip Dan 07:15 07:45 17.3',
          'Trip Dan 08:00 08:15 15'
        ]

        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to start_with('Dan: 32 miles')
      end

      it 'calculates the average speed' do
        driving_records = [
          'Driver Dan',
          'Trip Dan 07:15 07:45 17.3',
          'Trip Dan 08:00 08:15 15'
        ]

        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to end_with('@ 43 mph')
      end
    end

    describe 'When there are mixed entries including drivers with no trips' do
      it 'outputs all entries' do
        driving_records = [
          'Driver Dan',
          'Trip Dan 07:15 07:45 17.3',
          'Driver Edward'
        ]

        report_lines = calculator.calc(driving_records)

        expect(report_lines.length).to eq(2)
        expect(report_lines[0]).to eq('Dan: 17 miles @ 35 mph')
        expect(report_lines[1]).to eq('Edward: 0 miles')
      end
    end


end
