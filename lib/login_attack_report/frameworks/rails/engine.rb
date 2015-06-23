module LoginAttackReport
  module Rails
    class Engine < ::Rails::Engine
      paths['app/models'] << 'lib/login_attack_report/frameworks/active_record/models'
    end
  end
end
