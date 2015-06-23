require 'login_attack_report/version'
require 'active_support'
require 'login_attack_report/frameworks/active_record'

module LoginAttackReport
  # Your code goes here...
  def self.new_method # "call new_method"という文字列を返すだけのメソッド
    "call new_method"
  end
end

ActiveSupport.on_load(:active_record) do
  include PaperTrail::Model
end
