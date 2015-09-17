desc 'Lists all of the address formatting rules that are unique'
task :list_unique_formatting_rules do
  require 'local_postal'

  files = Dir[File.join(LocalPostal.root, 'config', 'formats', '*.json')]
  formats = files.map {|file| LocalPostal::Format.from_json(file) }

  rules = {
    administrative_area_type: [],
    dependent_locality_type: [],
    format: [],
    locale: [],
    locality_type: [],
    postal_code_pattern: [],
    postal_code_prefix: [],
    postal_code_type: [],
    required_fields: [],
    translations: [],
    uppercase_fields: []
  }

  formats.each do |format|
    rules.keys.each do |key|
      value = format.public_send(key)
      rules[key] << value unless value.nil?
    end
  end

  rules.keys.each {|key| rules[key] = rules[key].flatten.uniq }

  puts rules.to_yaml
end
