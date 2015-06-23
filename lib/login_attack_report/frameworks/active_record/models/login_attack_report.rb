require 'login_attack_report/version_concern'

module LoginAttackReport
  class LoginAttackReport < ::ActiveRecord::Base
    include LoginAttackReport::LoginAttackReportConcern
  end
end
