describe Driver do

  it 'should have a name' do
    expected_name = 'expected_name'
    driver = Driver.new(expected_name)

    expect(driver.name).to eq(expected_name)
  end

  it 'should have a default distance of 0' do
    driver = Driver.new('random')

    expect(driver.distance).to eq(0)
  end
end