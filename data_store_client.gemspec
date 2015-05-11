# -*- encoding: utf-8 -*-
require File.expand_path('../lib/data_store_client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Vinaya L Shrestha']
  gem.email         = ['vinaya.shrestha@craftdata.co']
  gem.description   = %q{An interface to data_store_api}
  gem.summary       = %q{An interface to data_store_api}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'data_store_client'
  gem.require_paths = ['lib']
  gem.version       = DataStoreClient::VERSION

  gem.add_dependency 'typhoeus', ['>= 0.4.2']
  gem.add_dependency 'activesupport', ['>= 3.2.17']
  gem.add_development_dependency 'rspec', ['~> 2.14.0']
  gem.add_development_dependency 'pry', ['~> 0.9.12.6']
end
