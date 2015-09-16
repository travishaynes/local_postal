class LocalPostal::Address
  attr_reader :attributes

  # All of the address fields that are available.
  #
  # @return [Array] Address field names as Symbols.
  def self.fields
    %i[ name department company street_address secondary_address city region
        postal_code country ]
  end

  # Constructs an empty set of attributes that contains all the address fields
  # with nil values.
  #
  # @return [Hash] Address attributes with nil values.
  def self.empty_attributes
    fields.inject({}) {|r, (key, value)| r[key] = nil; r }
  end

  # Assign getters and setters for each of the address fields that will use the
  # attributes hash to store their values.
  fields.each do |field|
    define_method(:"#{field}") { attributes[field] }
    define_method(:"#{field}=") {|value| attributes[field] = value }
  end

  # Constructs a new LocalPostal::Address with the supplied attributes assigned.
  #
  # @param [Hash] attributes The initial address attributes to assign.
  # @return [LocalPostal::Address] A new address.
  # @raise [ArgumentError] If the attributes contain any invalid field names.
  def initialize(attributes={})
    attributes.each do |k, _|
      next if self.class.fields.include?("#{k}".to_sym)

      fail ArgumentError, "invalid attribute: #{k.inspect}", caller
    end

    @attributes = self.class.empty_attributes.merge(attributes)
  end

  # The 2-character ISO 3166 country code for this address.
  #
  # @return [String] The country's ISO code or nil when unavailable.
  def country_code
    cc = carmen_country

    return if cc.nil?

    cc.code.upcase if cc.code.is_a?(String)
  end

  # The city line part of the address.
  #
  # @return [String] The address' city line.
  def city_line
    LocalPostal::CityLine.new(city, region, postal_code, country_code).to_s
  end

  # The address' lines as they should appear on the parcel.
  #
  # @return [Array] The address lines.
  def lines
    l = [
      name, department, company, street_address, secondary_address, city_line,
      country
    ]

    l.reject {|line| "#{line}".empty? }
  end

  private

  # Looks the country up using Carmen and returns its 2-character code when
  # available.
  #
  # @return [String] The country code or nil when unavailable.
  def carmen_country
    return unless country.is_a?(String)

    Carmen::Country.named(country) || Carmen::Country.coded(country)
  end
end
