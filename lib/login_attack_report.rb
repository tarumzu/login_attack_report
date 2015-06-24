require 'login_attack_report/version'
require 'active_support'
require 'active_record'
require 'paper_trail'

Dir[File.join(File.dirname(__FILE__), 'login_attack_report', '*.rb')].each do |file|
  require File.join('login_attack_report', File.basename(file, '.rb'))
end
require 'login_attack_report/frameworks/active_record'

module LoginAttackReport

  # login ok limit
  mattr_accessor :login_ok_limit
  @@login_ok_limit = 200

  # login ng limit
  mattr_accessor :login_ng_limit
  @@login_ng_limit = 50

  # config/initializers/login_attack_report.rb
  def self.setup
    yield self
  end
end
