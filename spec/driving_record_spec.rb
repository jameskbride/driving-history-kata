describe DrivingRecord do

  it 'has a name' do
    expected_name = 'expected_name'

    driving_record = DrivingRecord.new(expected_name)

    expect(driving_record.name).to eq(expected_name)
  end
end