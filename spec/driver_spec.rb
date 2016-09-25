describe Driver do

  it 'has a name' do
    expected_name = 'expected_name'
    driver = Driver.new(expected_name)

    expect(driver.name).to eq(expected_name)
  end

  it 'has a default distance of 0' do
    driver = Driver.new('random')

    expect(driver.distance).to eq(0)
  end
end