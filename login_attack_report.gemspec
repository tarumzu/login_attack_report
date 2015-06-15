$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'login_attack_report/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'login_attack_report'
  s.version       = LoginAttackReport::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['taru m']
  s.email         = ['TODO: Your email']
  s.homepage      = 'https://github.com/taru-m/' + s.name
  s.summary       = 'login attack report in Rails.'
  s.description   = s.summary
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'paper_trail', '~> 3.0.0'
  s.add_dependency 'devise', '~> 3.2.2'
end
