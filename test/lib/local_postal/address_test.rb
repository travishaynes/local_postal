require 'test_helper'

class LocalPostal::AddressTest < Minitest::Test
  def test_initializer_sets_attributes
    address = LocalPostal::Address.new(name: 'Travis')

    assert_equal 'Travis', address.name
  end

  def test_attributes_can_be_set_after_initializing
    address = LocalPostal::Address.new(name: 'Travis')
    address.name = 'John'

    assert_equal 'John', address.name
  end

  def test_country_code_when_country_is_a_full_name
    address = LocalPostal::Address.new(country: 'United States')

    assert_equal 'US', address.country_code
  end

  def test_country_code_when_country_is_two_characters
    address = LocalPostal::Address.new(country: 'US')

    assert_equal 'US', address.country_code
  end

  def test_country_code_when_country_is_three_characters
    address = LocalPostal::Address.new(country: 'USA')

    assert_equal 'US', address.country_code
  end

  def test_country_code_when_country_is_unknown
    address = LocalPostal::Address.new(country: 'Elbonia')

    assert_nil address.country_code
  end

  def test_country_code_when_country_is_nil
    address = LocalPostal::Address.new(country: nil)

    assert_nil address.country_code
  end

  def test_lines_when_all_fields_are_present
    address = fake_address
    lines = address.lines

    assert_equal address.name, lines[0]
    assert_equal address.department, lines[1]
    assert_equal address.company, lines[2]
    assert_equal address.street_address, lines[3]
    assert_equal address.secondary_address, lines[4]
    assert_equal address.city_line, lines[5]
    assert_equal address.country, lines[6]
  end

  def test_lines_when_some_fields_are_empty
    address = fake_address
    address.department = nil
    address.secondary_address = ''
    lines = address.lines

    assert_equal address.name, lines[0]
    assert_equal address.company, lines[1]
    assert_equal address.street_address, lines[2]
    assert_equal address.city_line, lines[3]
    assert_equal address.country, lines[4]
  end

  private

  def fake_address
    LocalPostal::Address.new(
      name: Faker::Name.name,
      department: Faker::Commerce.department,
      company: Faker::Company.name,
      street_address: Faker::Address.street_address,
      secondary_address: Faker::Address.secondary_address,
      city: Faker::Address.city,
      region: Faker::Address.state,
      postal_code: Faker::Address.zip,
      country: 'USA'
    )
  end
end