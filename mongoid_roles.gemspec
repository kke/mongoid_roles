# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid/roles/version"

Gem::Specification.new do |s|
  s.name        = "mongoid_roles"
  s.version     = MongoidRoles::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michal Wychowaniec"]
  s.email       = ["michal.wychowaniec@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Mongoid Roles}
  s.description = %q{Mongoid Roles}

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'mongoid', '2.0.0.rc.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
