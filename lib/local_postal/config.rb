module LocalPostal::Config
  # Reads a .yml file from the config folder.
  #
  # @param [Symbol] name The name of the .yml file without its extension.
  def self.load_yaml(name)
    yml = File.read(File.join(root, "#{name}.yml"))

    YAML.load(yml)
  end

  # The full path name for the config folder.
  #
  # @return [String] A path name.
  def self.root
    @root ||= File.expand_path(File.join('../../../config'), __FILE__)
  end
end
