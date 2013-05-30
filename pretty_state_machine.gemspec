$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pretty_state_machine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pretty_state_machine"
  s.license     = "MIT"
  s.version     = PrettyStateMachine::VERSION
  s.authors     = ["Alex Smith"]
  s.email       = ["alex@thatalexguy.com"]
  s.homepage    = "https://github.com/ags/pretty_state_machine"
  s.summary     = "Simple DSL for state machine classes"
  s.description = "Simple DSL for state machine classes"

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
