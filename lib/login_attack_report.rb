require 'login_attack_report/version'
require 'active_support'
require 'active_record'
require 'paper_trail'
require 'rails'

Dir[File.join(File.dirname(__FILE__), 'login_attack_report', '*.rb')].each do |file|
  require File.join('login_attack_report', File.basename(file, '.rb'))
end
require 'login_attack_report/frameworks/active_record'
require 'login_attack_report/frameworks/rails'

module LoginAttackReport
  # Your code goes here...
  def self.new_method # "call new_method"という文字列を返すだけのメソッド
    "call new_method"
  end
end

ActiveSupport.on_load(:active_record) do
  include LoginAttackReport::Model
end
