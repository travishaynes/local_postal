desc 'Lists all of the unique formatting variables'
task :list_unique_format_variables do
  require 'local_postal'

  files = Dir[File.join(LocalPostal.root, 'config', 'formats', '*.json')]
  formats = files.map {|file| LocalPostal::Format.from_json(file) }

  variables = formats.map {|f| f.variables }.flatten
  variables = variables.compact.uniq

  puts variables.to_yaml
end
