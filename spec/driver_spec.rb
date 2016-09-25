describe Driver do

  it 'should have a name' do
    expected_name = 'expected_name'
    driver = Driver.new(expected_name)

    expect(driver.name).to eq(expected_name)
  end
end