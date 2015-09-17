class LocalPostal::Address
  include ActiveModel::Model

  attr_accessor :name, :company
  attr_accessor :street_address, :secondary_address, :city, :region
  attr_accessor :postal_code

  attr_reader :format, :country

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
    address = format.formatted_string % formatting_values
    address.split("\n").reject {|line| line.strip.empty? } + [country]
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

  private

  # Maps the address fields to formatting variables.
  #
  # @return [Hash] Values that can be used to format the address.
  def formatting_values
    {
      recipient: name,
      organization: company,
      addressLine1: street_address,
      addressLine2: secondary_address,
      postalCode: postal_code,
      locality: city,
      administrativeArea: region,
      sortingCode: nil,
      dependentLocality: nil
    }
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
