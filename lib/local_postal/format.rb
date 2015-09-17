class LocalPostal::Format
  include ActiveModel::Model

  attr_accessor *%i[
    administrative_area_type
    dependent_locality_type
    format
    locale
    locality_type
    postal_code_pattern
    postal_code_prefix
    postal_code_type
    required_fields
    translations
    uppercase_fields
  ]

  # Constructs an instance of LocalPostal::Format from the supplied JSON file.
  #
  # @param [String] path The full pathname of the JSON file.
  # @return [LocalPostal::Format] The new LocalPostal::Format instance.
  def self.from_json(path)
    raw_json = File.read(path)
    parsed_json = JSON.parse(raw_json)

    new(parsed_json)
  end

  # Constructs an instance of LocalPostal::Format by looking up the supplied
  # country code in config/formats/*.json.
  #
  # @param [String] code The 2-character country code.
  # @raise [ArgumentError] If the code is not exactly 2 characters.
  # @raise [ArgumentError] If the supplied country code is not supported.
  # @return [LocalPostal::Format] The new LocalPostal::Format instance.
  def self.from_country_code(code)
    code = "#{code}".upcase

    fail ArgumentError, "#{code} is an invalid code", caller if code.length != 2

    path = File.join(LocalPostal::Config.root, 'formats', "#{code}.json")

    fail ArgumentError, "#{code} unsupported", caller unless File.file?(path)

    from_json(path)
  end

  # Converts the format provided in the JSON files into a valid Ruby formatted
  # String that can be parsed using the modulus operator and a Hash.
  def formatted_string
    format.dup.tap do |str|
      variables.each {|v| str.gsub!("%#{v}", "%{#{v}}") }
    end
  end

  # All of the variables found in the format.
  #
  # @return [Array] Variable names as Strings.
  def variables
    format.scan(/(%\w+)/).flatten.map {|v| v[1..v.length] }
  end
end
