require 'test_helper'

class LocalPostal::AddressTest < Minitest::Test
  def test_country_assigns_format
    address = LocalPostal::Address.new(country: 'United States')
    assert_kind_of LocalPostal::Format, address.format
    assert_equal 'en', address.format.locale

    address.country = 'Spain'
    assert_equal 'es', address.format.locale

    address.country = nil
    assert_nil address.format
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
    city_line = "#{address.city}, #{address.region} #{address.postal_code}"

    assert_equal address.name, lines[0]
    assert_equal address.company, lines[1]
    assert_equal address.street_address, lines[2]
    assert_equal address.secondary_address, lines[3]
    assert_equal city_line.upcase, lines[4]
    assert_equal 'UNITED STATES', lines[5]
  end

  def test_lines_when_some_fields_are_empty
    address = fake_address
    address.company = nil
    address.secondary_address = ''
    lines = address.lines
    city_line = "#{address.city}, #{address.region} #{address.postal_code}"

    assert_equal address.name, lines[0]
    assert_equal address.street_address, lines[1]
    assert_equal city_line.upcase, lines[2]
    assert_equal 'UNITED STATES', lines[3]
  end

  def test_validates_required_fields
    address = fake_address

    assert address.valid?

    address.name = nil
    address.street_address = nil

    refute address.valid?
    assert_includes address.errors.full_messages, 'Name is required'
    assert_includes address.errors.full_messages, 'Street address is required'
  end

  def test_validates_postal_code
    address = fake_address

    address.postal_code = 'x'
    refute address.valid?
    assert_includes address.errors.full_messages, 'Postal code is invalid'

    address.postal_code = '90210'
    assert address.valid?
  end

  def test_validates_postal_code_prefix
    address = fake_address

    address.country = 'AX'
    refute address.valid?
    assert_includes address.errors.full_messages, 'Postal code has an invalid prefix'

    address.postal_code = 'AX-22131'
    assert address.valid?
  end

  def test_full_country_name_used
    address = fake_address
    assert_equal 'UNITED STATES', address.lines.last

    address.country = 'CA'
    assert_equal 'CANADA', address.lines.last
  end

  private

  def fake_address
    LocalPostal::Address.new(
      name: Faker::Name.name,
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
