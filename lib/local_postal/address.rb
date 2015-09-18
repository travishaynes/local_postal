class LocalPostal::Address
  include ActiveModel::Model

  attr_accessor :name, :company
  attr_accessor :street_address, :secondary_address, :city, :region
  attr_accessor :postal_code

  attr_reader :format, :country

  validates :country, presence: true

  validate :has_required_fields
  validate :has_valid_postal_code_pattern, unless: -> { postal_code.nil? }
  validate :has_valid_postal_code_prefix, unless: -> { postal_code.nil? }

  # The 2-character ISO 3166 country code for this address.
  #
  # @return [String] The country's ISO code or nil when unavailable.
  def country_code
    cc = carmen_country

    cc ? "#{cc.code.upcase}" : nil
  end

  # The countries full name.
  #
  # @return [String] Name of the country.
  def country_name
    cc = carmen_country

    cc ? "#{cc.name}" : ''
  end

  # The address' lines as they should appear on the parcel.
  #
  # @return [Array] The address lines.
  def lines
    address = format.apply(formatting_values)
    lines = address.split("\n").reject {|line| line.strip.empty? }
    lines << country_name.upcase
  end

  # Sets the country and automatically assigns the correct format that it
  # belongs to.
  #
  # @param [String] value The name of the country.
  # @return [String] The supplied value.
  def country=(value)
    @country = value

    @format = case country_code
    when nil, '' then nil
    else LocalPostal::Format.from_country_code(country_code)
    end
  end

  # Maps the universal fields used in the formatting rules to the more commonly
  # used field names that Address uses.
  #
  # @return [Hash] Keys are formatting rule fields; values are Address fields.
  def self.formatting_variables_lookup_table
    {
      :recipient => :name,
      :organization => :company,
      :addressLine1 => :street_address,
      :addressLine2 => :secondary_address,
      :postalCode => :postal_code,
      :locality => :city,
      :administrativeArea => :region,
      :sortingCode => nil,
      :dependentLocality => nil
    }
  end

  private

  # Validates that all the required fields are present.
  def has_required_fields
    return unless format.is_a?(LocalPostal::Format)

    format.required_fields.each do |field|
      field_name = self.class.formatting_variables_lookup_table[field.to_sym]
      value = public_send(field_name)
      errors.add(field_name, 'is required') if "#{value}".empty?
    end
  end

  # Validates that the postal code is in the correct format.
  def has_valid_postal_code_pattern
    return unless format.is_a?(LocalPostal::Format)

    matches = Regexp.new(format.postal_code_pattern).match(postal_code)

    errors.add(:postal_code, 'is invalid') unless matches.to_a.length > 0
  end

  # Validates that the postal code has the correct prefix, when required.
  def has_valid_postal_code_prefix
    return unless format.is_a?(LocalPostal::Format)
    return if "#{format.postal_code_prefix}".empty?
    return if postal_code.start_with?("#{format.postal_code_prefix}")

    errors.add(:postal_code, 'has an invalid prefix')
  end

  # Maps the address fields to formatting variables.
  #
  # @return [Hash] Values that can be used to format the address.
  def formatting_values
    self.class.formatting_variables_lookup_table.map do |key, value|
      value = public_send(value) unless value.nil?

      [key, value]
    end.to_h
  end

  # Looks the country up using Carmen and returns its 2-character code when
  # available.
  #
  # @return [String] The country code or nil when unavailable.
  def carmen_country
    return unless country.is_a?(String)

    Carmen::Country.named(country) || Carmen::Country.coded(country)
  end
end
