desc 'Lists all the countries that are supported'
task :list_supported_countries do
  require 'local_postal'

  files = Dir[File.join(LocalPostal.root, 'config', 'formats', '*.json')]

  countries = files.sort.map do |file|
    country_code = File.basename(file, File.extname(file))
    country = Carmen::Country.coded(country_code)
    name = country ? country.name : nil

    { country_code => name }
  end

  total = Carmen::Country.all.count

  print "# #{countries.count} of #{total} countries are supported as of "
  puts Time.now.strftime('%B %d, %Y')
  puts
  puts countries.to_yaml
end
