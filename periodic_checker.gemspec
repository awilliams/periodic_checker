# -*- encoding: utf-8 -*-
require File.expand_path('../lib/periodic_checker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Williams"]
  gem.email         = ["pwnfactory@gmail.com"]
  gem.description   = %q{Ruby library which helps create groups of EventMachine::PeriodicTimers. Each checker has a #check method which is called periodically and an #update method which is called when #check returns a changed value}
  gem.summary       = %q{Ruby library which helps create groups of EventMachine::PeriodicTimers}
  gem.homepage      = "https://github.com/awilliams/periodic_checker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "periodic_checker"
  gem.require_paths = ["lib"]
  gem.version       = PeriodicChecker::VERSION

  gem.add_dependency "eventmachine", "~> 1.0.0"

  gem.add_development_dependency "pry"
  gem.add_development_dependency "awesome_print"
end
