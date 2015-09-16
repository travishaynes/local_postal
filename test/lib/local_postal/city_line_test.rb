require 'test_helper'

class LocalPostal::CityLineTest < Minitest::Test
  def test_formats_are_loaded_and_properly_formatted
    assert_kind_of Array, formats
    assert_operator formats.count, :>, 0

    formats.each_with_index do |f, index|
      assert_kind_of Hash, f, "item #{index}"
      assert_includes f.keys, 'format', "item #{index}"
      assert_includes f.keys, 'country_codes', "item #{index}"
    end
  end

  def test_country_codes_are_all_arrays
    types = formats.map {|f| f['country_codes'] }.map(&:class).uniq
    assert_equal [Array], types, 'some country_codes are not arrays'
  end

  def test_formats_are_all_strings
    types = formats.map {|f| f['format'] }.map(&:class).uniq
    assert_equal [String], types, 'some formats are not strings'
  end

  def test_country_codes_are_all_two_character_uppercase_strings
    codes = formats.map {|f| f['country_codes'] }.flatten
    types = codes.map(&:class).uniq
    sizes = codes.map(&:length).uniq
    upcased = codes.map(&:upcase)

    assert_equal [String], types, 'some country codes are not strings'
    assert_equal [2], sizes, 'some country codes are not 2 characters'
    assert_equal codes, upcased, 'some country codes are not upper-case'
  end

  def test_no_duplicate_country_codes
    codes = formats.map {|f| f['country_codes'] }.flatten
    dup = codes.detect {|code| codes.count(code) > 1 }

    assert_nil dup, "#{dup.inspect} is listed more than once"
  end

  def test_no_duplicate_formats
    fs = formats.map {|f| f['format'] }
    dup = fs.detect {|f| fs.count(f) > 1 }

    assert_nil dup, "#{dup.inspect} is listed more than once"
  end

  def test_format_is_pulled_from_country_code
    city = Faker::Address.city
    region = Faker::Address.state
    postal_code = Faker::Address.zip_code

    city_line = LocalPostal::CityLine.new(city, region, postal_code, 'CN')
    assert_equal "%{city}, %{region}  %{postal_code}", city_line.format

    city_line = LocalPostal::CityLine.new(city, region, postal_code, 'US')
    assert_equal "%{city} %{region}  %{postal_code}", city_line.format
  end

  def test_city_line_to_s
    city = Faker::Address.city
    region = Faker::Address.state
    postal_code = Faker::Address.zip_code

    city_line = LocalPostal::CityLine.new(city, region, postal_code, 'US')

    assert_equal "#{city} #{region}  #{postal_code}", "#{city_line}"
  end

  private

  def formats
    LocalPostal::CityLine::FORMATS
  end
end
