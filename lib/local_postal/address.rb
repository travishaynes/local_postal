class LocalPostal::Address
  include ActiveModel::Model

  attr_accessor :name, :department, :company
  attr_accessor :street_address, :secondary_address, :city, :region
  attr_accessor :postal_code, :country

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
