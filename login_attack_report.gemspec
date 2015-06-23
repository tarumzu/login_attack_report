# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'login_attack_report/version'

Gem::Specification.new do |spec|
  spec.name          = 'login_attack_report'
  spec.version       = LoginAttackReport::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['taru m']
  spec.email         = ['Write your email address']
  spec.summary       = %q{login attack report in Rails.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/taru-m/' + spec.name
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_rubygems_version = '>= 1.9.0'

  spec.add_dependency 'activerecord', ['>= 3.0', '< 6.0']
  spec.add_dependency 'activesupport', ['>= 3.0', '< 6.0']
  spec.add_dependency 'paper_trail', ['>= 3.0', '< 6.0']
  spec.add_dependency 'devise', '>= 3.2.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
