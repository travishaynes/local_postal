require 'yaml'
require 'json'
require 'carmen'
require 'active_model'

module LocalPostal
  autoload :Address, 'local_postal/address'
  autoload :Config, 'local_postal/config'
  autoload :CityLine, 'local_postal/city_line'
  autoload :Format, 'local_postal/format'
  autoload :VERSION, 'local_postal/version'
end
