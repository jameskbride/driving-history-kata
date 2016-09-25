describe DrivingRecord do

  it 'has a name' do
    expected_name = 'expected_name'

    driving_record = DrivingRecord.new(expected_name)

    expect(driving_record.name).to eq(expected_name)
  end

  it 'can calculate the total trip minutes' do
    driving_record = DrivingRecord.new('short')
    driving_record.add_record(Trip.new('short', 5.0, '07:15', '07:45'))
    driving_record.add_record(Trip.new('longer', 10.5, '08:00', '09:00'))

    expect(driving_record.calc_total_minutes).to eq(90)
  end

  it 'can calculate the average speed for a single trip' do
    driving_record = DrivingRecord.new('short')
    driving_record.add_record(Trip.new('short', 17.3, '07:15', '07:45'))

    expect(driving_record.calc_average_speed).to eq(35)
  end

  describe 'when sorting' do
    it 'compares the total distance' do
      shorter_record = DrivingRecord.new('short')
      shorter_record.add_record(Trip.new('short', 5.0))

      longer_record = DrivingRecord.new('longer')
      longer_record.add_record(Trip.new('longer', 10.5))

      expect(longer_record).to be < (shorter_record)
    end
  end

  describe 'when converting to a string' do

    before(:example) do
      @driving_record = DrivingRecord.new('short')
      @driving_record.add_record(Trip.new('short', 17.3, '07:15', '07:45'))
    end

    it 'includes the driver name' do
      expect(@driving_record.to_s).to start_with('short:')
    end

    it 'includes the total distance' do
      expect(@driving_record.to_s).to match(/.*17 miles.*/)
    end

    it 'includes the average speed' do
      expect(@driving_record.to_s).to end_with('@ 35 mph')
    end
  end
end