require 'test_helper'

class AddressFormattingTest < Minitest::Test
  # Gets a list of all the fixtures that contain properly formatted addresses.
  #
  # @return [Array] File names.
  def self.formatting_fixtures
    @address_fixtures ||= Dir[
      File.join(LocalPostal.root, 'test', 'fixtures', '*.yml')
    ]
  end

  # The tests are dynamically generated based on the .yml files in the
  # test/fixtures folder. The fixtures should contain an array of hashes. Each
  # element in the array should contain attributes for a LocalPostal::Address,
  # and the lines that the address should be formatted into.
  #
  # @param [String] file The full path to the fixture file.
  # @return [Symbol] The name of the test method that was created.
  def self.create_test(file)
    country = File.basename(file, File.extname(file))

    define_method(:"test_#{country}_formatting") do
      formatting(file).each_with_index do |f, i|
        assert_valid_address_from_attributes(f['attributes'], f['lines'])
      end
    end
  end

  # Creates the test methods.
  formatting_fixtures.each {|file| create_test(file) }

  private

  # Checks that a valid address can be created from the supplied attributes
  # that formats into the given lines.
  #
  # @param [Hash] attributes Attributes for a LocalPostal::Address.
  # @param [Array] lines The expected address lines.
  def assert_valid_address_from_attributes(attributes, lines)
    address = LocalPostal::Address.new(attributes)

    assert address.valid?, address.errors.full_messages.join(' and ')
    assert_equal lines, address.lines, 'invalid address lines'
  end

  # Reads the formatting from a .yml file.
  #
  # @param [String] file The full path to the .yml file.
  # @return [Array] A list of address attributes and formatted lines.
  def formatting(file)
    data = File.read(file)

    YAML.load(data)
  end
end
