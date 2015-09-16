class LocalPostal::CityLine
  FORMATS = LocalPostal::Config.load_yaml(:city_line_formatting)

  attr_reader :city, :region, :postal_code, :country_code

  def initialize(city, region, postal_code, country_code)
    @city = city
    @region = region
    @postal_code = postal_code
    @country_code = country_code
  end

  def to_s
    format % { city: city, region: region, postal_code: postal_code }
  end

  def format
    self.class.format_for_country_code(country_code)['format']
  end

  def self.format_for_country_code(country_code)
    FORMATS.detect {|f| Array(f['country_codes']).include?(country_code) }
  end
end
