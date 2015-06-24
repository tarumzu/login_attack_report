require 'login_attack_report/l_a_r_version_concern'

module LoginAttackReport
  class LARVersion < ::ActiveRecord::Base
    include LoginAttackReport::LARVersionConcern
  end
end
