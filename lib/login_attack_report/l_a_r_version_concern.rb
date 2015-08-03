require 'active_support/concern'

module LoginAttackReport
  module LARVersionConcern
    extend ::ActiveSupport::Concern

    module ClassMethods
      def login_ok_limit_over(model)
        PaperTrail::Version
          .where(item_type: model) \
          .where(
            'created_at >= ? and created_at <= ? and ' \
            + 'object_changes like \'%sign_in_count:%\'' \
            , Time.now.prev_month.beginning_of_month \
            , Time.now.prev_month.end_of_month
          ).select('versions.*, count(item_id) as attack_count') \
          .group(:item_id).having('count(item_id) > ?', LoginAttackReport.login_ok_limit)
      end

      def login_ng_limit_over(model)
        PaperTrail::Version
          .where(item_type: model)
          .where(
            'created_at >= ? and created_at <= ? and ' \
            + 'object_changes not like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:\n- _\n- 0%\' and ' \
            + 'object_changes not like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:\n- __\n- 0%\' and ' \
            + 'object_changes like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:%\'' \
            , Time.now.prev_month.beginning_of_month \
            , Time.now.prev_month.end_of_month
          ).select('versions.*, count(item_id) as attack_count') \
          .group(:item_id).having('count(item_id) > ?', LoginAttackReport.login_ng_limit)
      end

      def ip_limit_over(model)
        ips = {}
        alert_ip_limit_over = PaperTrail::Version
                              .where(item_type: model)
                              .where(
                                'created_at >= ? and created_at <= ? and '\
                                + '(object_changes not like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:\n- _\n- 0%\' and '\
                                  + 'object_changes not like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:\n- __\n- 0%\' and '\
                                  + 'object_changes like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:%\''\
                                + ')',
                                Time.now.prev_month.beginning_of_month,
                                Time.now.prev_month.end_of_month
                              )

        if alert_ip_limit_over.present?
          ng_hash = Hash.new({})
          alert_ip_limit_over.find_each do |version|
            # アクセス元ipアドレス取得
            if /current_sign_in_ip/ =~ version.object_changes
              current_sign_in_ip = YAML.load(version.object_changes)['current_sign_in_ip'][1]
            else
              current_sign_in_ip = YAML.load(version.object)['current_sign_in_ip']
            end
            if ng_hash[current_sign_in_ip].present?
              ng_hash[current_sign_in_ip] += 1
            else
              ng_hash[current_sign_in_ip] = 1
            end
          end
          ng_hash.each do |key, ng_count|
            ips[key] = ng_count if ng_count.to_i > LoginAttackReport.same_ip_login_ng_limit
          end
        end
        ips
      end
    end
  end
end
