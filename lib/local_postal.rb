require 'yaml'
require 'json'
require 'carmen'
require 'active_model'

module LocalPostal
  autoload :Address, 'local_postal/address'
  autoload :Format, 'local_postal/format'
  autoload :VERSION, 'local_postal/version'

  # Gets the path that the gem was installed in. This is used mainly to read
  # configuration files.
  #
  # @return [String] The path the gem is installed in.
  def self.root
    @root ||= File.expand_path(File.join('..', '..'), __FILE__)
  end
end
