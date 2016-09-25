describe RecordParser do

  it 'can parse a Driver record' do
    driver = RecordParser::parse('Driver Dan')

    expect(driver.name).to eq('Dan')
  end
end