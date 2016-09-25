describe DrivingHistoryCalculator do

    describe 'When given no records' do
      it 'outputs an empty report' do
        calculator = DrivingHistoryCalculator.new([])
        report_lines = calculator.generate_report_lines()

        expect(report_lines).to be_empty
      end
    end

    describe 'When only Driver entries are found' do

      it 'can parse a single driver record' do
        driving_records = [
            'Driver Dan'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)

        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to eq('Dan: 0 miles')
      end

      it 'can parse multiple driver records' do
        driving_records = [
            'Driver Dan',
            'Driver Steve'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)

        report_lines = calculator.generate_report_lines()

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
        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to start_with('Dan: 17 miles')
      end

      it 'calculates the speed' do
        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

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

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to start_with('Dan: 32 miles')
      end

      it 'calculates the average speed' do
        driving_records = [
            'Driver Dan',
            'Trip Dan 07:15 07:45 17.3',
            'Trip Dan 08:00 08:15 15'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(1)
        expect(report_lines[0]).to end_with('@ 43 mph')
      end
    end

    describe 'multiple drivers' do
      it 'includes multiple drivers with trips' do
        driving_records = [
            'Driver Dan',
            'Trip Dan 07:15 07:45 17.3',
            'Driver Edward',
            'Trip Edward 06:30 06:45 10.7'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(2)
        expect(report_lines[0]).to eq('Dan: 17 miles @ 35 mph')
        expect(report_lines[1]).to eq('Edward: 11 miles @ 43 mph')
      end

      it 'includes all drivers whether they have trips or not' do
        driving_records = [
            'Driver Dan',
            'Trip Dan 07:15 07:45 17.3',
            'Driver Edward'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(2)
        expect(report_lines[0]).to start_with('Dan: 17 miles')
        expect(report_lines[1]).to eq('Edward: 0 miles')
      end

      it 'sorts trips by total distance' do
        driving_records = [
            'Driver Dan',
            'Driver Steve',
            'Driver Edward',
            'Trip Edward 06:30 06:45 10.7',
            'Trip Dan 07:15 07:45 17.3',
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(3)
        expect(report_lines[0]).to start_with('Dan: 17 miles')
        expect(report_lines[1]).to start_with('Edward: 11 miles')
        expect(report_lines[2]).to eq('Steve: 0 miles')
      end
    end

    describe 'When there are extremely slow or fast trips' do
      it 'excludes trips with speeds less than 5 mph' do
        driving_records = [
            'Driver Dan',
            'Trip Dan 07:15 08:15 2.5',
            'Driver Edward',
            'Trip Edward 06:30 06:45 10.7'
        ]

        calculator = DrivingHistoryCalculator.new(driving_records)
        report_lines = calculator.generate_report_lines()

        expect(report_lines.length).to eq(2)
        expect(report_lines[0]).to eq('Edward: 11 miles @ 43 mph')
        expect(report_lines[1]).to eq('Dan: 0 miles')
      end

          it 'excludes trips with speeds greater than 100 mph' do
            driving_records = [
                'Driver Dan',
                'Trip Dan 07:15 07:45 60',
                'Driver Edward',
                'Trip Edward 06:30 06:45 10.7'
            ]

            calculator = DrivingHistoryCalculator.new(driving_records)
            report_lines = calculator.generate_report_lines()

            expect(report_lines.length).to eq(2)
            expect(report_lines[0]).to eq('Edward: 11 miles @ 43 mph')
            expect(report_lines[1]).to eq('Dan: 0 miles')
          end
    end

  it 'ignores duplicate Driver entries' do
    driving_records = [
        'Driver Dan',
        'Driver Dan',
        'Driver Edward',
        'Driver Edward',
        'Trip Edward 06:30 06:45 10.7'
    ]

    calculator = DrivingHistoryCalculator.new(driving_records)
    report_lines = calculator.generate_report_lines()

    expect(report_lines.length).to eq(2)
    expect(report_lines[0]).to eq('Edward: 11 miles @ 43 mph')
    expect(report_lines[1]).to eq('Dan: 0 miles')
  end

  it 'ignores entries with unknown commands' do
      driving_records = [
          'Driver Edward',
          'Trip Edward 06:30 06:45 10.7',
          'Passenger Alphonse'
      ]

      calculator = DrivingHistoryCalculator.new(driving_records)
      report_lines = calculator.generate_report_lines()

      expect(report_lines.length).to eq(1)
      expect(report_lines[0]).to eq('Edward: 11 miles @ 43 mph')
  end

  # it 'ignores entries which are not formatted correctly' do
  #   driving_records = [
  #       'Driver Dan',
  #       'Trip Dan 07:15 07:45 60',
  #       'Driver Edward',
  #       'Trip Edward zz:30 06:45 10.7'
  #   ]
  #
  #   report_lines = calculator.calc(driving_records)
  #
  #   expect(report_lines.length).to eq(2)
  #   expect(report_lines[0]).to eq('Dan: 0 miles')
  #   expect(report_lines[1]).to eq('Edward: 0 miles')
  # end
end
