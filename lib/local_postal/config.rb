module LocalPostal::Config
  def self.load_yaml(*path)
    path = path.map(&:to_s)
    path[path.length-1] += '.yml'
    yml = File.read(File.join(root, *path))
    YAML.load(yml)
  end

  def self.root
    @root ||= File.expand_path(File.join('../../../config'), __FILE__)
  end
end
