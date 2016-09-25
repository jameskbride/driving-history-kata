describe DrivingRecord do

  it 'has a name' do
    expected_name = 'expected_name'

    driving_record = DrivingRecord.new(expected_name)

    expect(driving_record.name).to eq(expected_name)
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
end