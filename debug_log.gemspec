# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "debug_log/version"

Gem::Specification.new do |s|
  s.name        = "debug_log"
  s.version     = DebugLog::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Marklund"]
  s.email       = ["peter@marklunds.com"]
  s.homepage    = "http://rubygems.org/gems/debug_log"
  s.summary     = %q{A more powerful way to do debug printouts than puts}
  s.description = <<-END
  Allows you to easily and readably printout variable values (or any other Ruby expressions) to stdout
  and/or any number of logger objects of your choice for debugging purposes. The approach to accessing
  the binding object was inspired by the dp gem by Niclas Nilsson.
  END

  s.rubyforge_project = "debug_log"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "2.0.0"
  s.add_development_dependency "mocha", "~> 0.9.9"
end
