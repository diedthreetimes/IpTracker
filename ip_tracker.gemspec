# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ip_tracker/version"

Gem::Specification.new do |s|
  s.name        = "ip_tracker"
  s.version     = IpTracker::VERSION
  s.authors     = ["Sky Faber"]
  s.email       = ["skyfaber@gmail.com"]
  s.homepage    = "https://github.com/diedthreetimes/IpTracker"
  s.summary     = %q{A command line utility to interface with IpMe}
  s.description = %q{Keep a dynamic IP up to date without the use of DNS. Either sync manually or automatically to a known location.}

  s.rubyforge_project = "ip_tracker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", '~> 2.6'
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-readline"
  s.add_development_dependency "webmock"

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "faraday_middleware"
  s.add_runtime_dependency "yajl-ruby"
  s.add_runtime_dependency "multi_json"
  s.add_runtime_dependency "rash"
  s.add_runtime_dependency "looper"
end
