require 'login_attack_report/login_attack_report_version_concern'

module LoginAttackReport
  class LoginAttackReportVersion < ::ActiveRecord::Base
    include LoginAttackReport::LoginAttackReportVersionConcern
  end
end
