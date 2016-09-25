describe Trip do

  it 'has a name' do
    expected_name = 'expected_name'

    trip = Trip.new(expected_name)

    expect(trip.name).to eq(expected_name)
  end

  it 'has a default distance' do
    trip = Trip.new('random')

    expect(trip.distance).to eq(0)
  end

  it 'can have a set distance' do
    trip = Trip.new('random', 17.3)

    expect(trip.distance).to eq(17.3)
  end

  it 'can have a start time' do
    trip = Trip.new('random', 17.3, '07:15')

    expect(trip.start_time).to eq('07:15')
  end

  it 'can have an end time' do
    trip = Trip.new('random', 17.3, '07:15', '08:15')

    expect(trip.end_time).to eq('08:15')
  end

  it 'can calculate the trip minutes' do
    trip = Trip.new('random', 17.3, '07:15', '08:15')

    expect(trip.calc_minutes).to eq(60)
  end

  describe 'when calculating trip speed' do
    it 'calculates 0 when minutes are 0' do
      trip = Trip.new('random', 0, '07:15', '07:15')

      expect(trip.calc_trip_speed).to eq(0)
    end

    it 'calculates the trip speed when minutes are greater than 0' do
      trip = Trip.new('random', 17.3, '07:15', '07:45')

      expect(trip.calc_trip_speed).to eq(35)
    end
  end

end