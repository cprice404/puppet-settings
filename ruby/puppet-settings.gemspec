Gem::Specification.new do |s|
  s.name        = 'puppet-settings'
  s.version     = '0.1.0'
  s.date        = '2016-06-28'
  s.summary     = "Puppet Settings Ruby Library"
  s.description = "== A Ruby library for parsing Puppet settings"
  s.authors     = ["Chris Price"]
  s.email       = 'chris@puppetlabs.com'
  s.files       = Dir["{lib}/**/*.rb", "spec/**/*" , "bin/*", "LICENSE", "*.md"]
  s.require_paths = ["lib"]
  s.homepage      = 'https://github.com/cprice404/puppet-settings'
  s.license       = 'Apache License, v2'
  s.required_ruby_version = '>=1.9.0'

  # Testing dependencies
  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rspec', '~> 2.14'
end
