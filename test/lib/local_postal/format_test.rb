require 'test_helper'

class LocalPostal::FormatTest < Minitest::Test
  def test_all_config_files_will_instantiate
    config_files.each {|file| LocalPostal::Format.from_json(file) }
  end

  def test_formatted_string
    f = LocalPostal::Format.new(format: "%one, %two\n%three x %d(%e)-%f")
    converted_format = "%{one}, %{two}\n%{three} x %{d}(%{e})-%{f}"
    assert_equal converted_format, f.formatted_string
  end

  def test_from_country_code
    f = LocalPostal::Format.from_country_code(:US)
    assert_kind_of LocalPostal::Format, f
  end

  def test_from_country_code_with_invalid_arguments
    assert_raises(ArgumentError) { LocalPostal::Format.from_country_code(:USA) }
  end

  def test_variables
    f = LocalPostal::Format.from_country_code(:US)

    assert_equal 7, f.variables.length
    assert_includes f.variables, 'addressLine1'
    assert_includes f.variables, 'addressLine2'
    assert_includes f.variables, 'administrativeArea'
    assert_includes f.variables, 'locality'
    assert_includes f.variables, 'organization'
    assert_includes f.variables, 'postalCode'
    assert_includes f.variables, 'recipient'
  end

  private

  def config_files
    Dir[File.join(LocalPostal::Config.root, 'formats', '*.json')]
  end
end
