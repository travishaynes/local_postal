# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'local_postal/version'

Gem::Specification.new do |spec|
  spec.name = 'local_postal'
  spec.version = LocalPostal::VERSION
  spec.authors = ['Travis Haynes']
  spec.email = ['travis@hi5dev.com']
  spec.summary = 'Provides localized formating for postal addresses.'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'

  spec.executables = spec.files.grep(%r{^#{spec.bindir}/}) do |f|
    File.basename(f)
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'byebug'
end
