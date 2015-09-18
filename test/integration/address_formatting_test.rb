require 'test_helper'

class AddressFormattingTest < Minitest::Test
  Dir[File.join(LocalPostal.root, 'test', 'fixtures', '*.yml')].each do |file|
    country = File.basename(file, File.extname(file))

    define_method(:"test_#{country}_formatting") do
      country_formatting_test(country, file)
    end
  end

  def country_formatting_test(country, file)
    formatting(file).each_with_index do |f, i|
      address = LocalPostal::Address.new(f['attributes'])
      assert address.valid?,
        "address #{country} #{i}: #{address.errors.full_messages.join(' and ')}"

      assert_equal f['lines'], address.lines,
        "incorrect formatting for #{country}"
    end
  end

  private

  def formatting(file)
    data = File.read(file)
    YAML.load(data)
  end
end
