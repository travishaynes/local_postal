class LocalPostal::Address
  include ActiveModel::Model

  attr_accessor :name, :company
  attr_accessor :street_address, :secondary_address, :city, :region
  attr_accessor :postal_code

  attr_reader :format, :country

  validate :has_required_fields
  validate :has_valid_postal_code

  # The 2-character ISO 3166 country code for this address.
  #
  # @return [String] The country's ISO code or nil when unavailable.
  def country_code
    cc = carmen_country

    return if cc.nil?

    cc.code.upcase if cc.code.is_a?(String)
  end

  # The address' lines as they should appear on the parcel.
  #
  # @return [Array] The address lines.
  def lines
    address = format.apply(formatting_values)
    address.split("\n").reject {|line| line.strip.empty? } + [country.upcase]
  end

  # Sets the country and automatically assigns the correct format for that it
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
      errors.add field_name, 'is required' if "#{value}".empty?
    end
  end

  # Validates the postal code.
  def has_valid_postal_code
    return unless format.is_a?(LocalPostal::Format)

    # TODO: validate postal code
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
