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

end