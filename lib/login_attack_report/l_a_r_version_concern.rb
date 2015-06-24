require 'active_support/concern'

module LoginAttackReport
  module LARVersionConcern
    extend ::ActiveSupport::Concern

    module ClassMethods
      def login_ok_limit_over(model)
        PaperTrail::Version
          .where(item_type: model)
          .where(
            'created_at >= ? and created_at <= ? and '\
            'object_changes like \'%sign_in_count:%\'',
            Time.now.prev_month.beginning_of_month,
            Time.now.prev_month.end_of_month
          ).group(:item_id).having("count(item_id) > #{LoginAttackReport.login_ok_limit}")
      end

      def login_ng_limit_over(model)
        PaperTrail::Version
          .where(item_type: model)
          .where(
            'created_at >= ? and created_at <= ? and ' \
            'object_changes like \'%sign_in_count:%\'',
            Time.now.prev_month.beginning_of_month,
            Time.now.prev_month.end_of_month
          ).group(:item_id).having("count(item_id) > #{LoginAttackReport.login_ng_limit}")
      end

      def ip_limit_over(model)
        alert_ip_limit_over = PaperTrail::Version
                              .where(item_type: model)
                              .where(
                                'created_at >= ? and created_at <= ? and '\
                                '(object_changes like \'%sign_in_count:%\' or '\
                                  'object_changes like \'--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nfailed_attempts:%\'' \
                                ')',
                                Time.now.prev_month.beginning_of_month,
                                Time.now.prev_month.end_of_month
                              )

        if alert_ip_limit_over.present?
          ok_hash = Hash.new({})
          ng_hash = Hash.new({})
          alert_ip_limit_over.find_each do |version|
            # アクセス元ipアドレス取得
            if /current_sign_in_ip/ =~ version.object_changes
              current_sign_in_ip = YAML.load(version.object_changes)['current_sign_in_ip'][1]
            else
              current_sign_in_ip = YAML.load(version.object)['current_sign_in_ip']
            end
            # ログイン成功回数取得
            if /sign_in_count/ =~ version.object_changes
              if ok_hash[current_sign_in_ip].present?
                ok_hash[current_sign_in_ip] += 1
              else
                ok_hash[current_sign_in_ip] = 1
              end
            # ログイン失敗回数取得
            else
              if ng_hash[current_sign_in_ip].present?
                ng_hash[current_sign_in_ip] += 1
              else
                ng_hash[current_sign_in_ip] = 1
              end
            end
          end
        end
      end
    end
  end
end
