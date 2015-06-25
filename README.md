# LoginAttackReport

攻撃性のあるログインを判定します。

## Installation

Add this line to your application's Gemfile:
'devise' and 'paper_trail' is required

```ruby
gem 'devise'
gem 'paper_trail'

gem 'login_attack_report'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install login_attack_report

## Configuring

・models  
app/models/user.rb
```ruby
  devise ... , :lockable # enable devise lockable and add table column 'failed_attempts'
  has_paper_trail  # enable paper_trail
```


・initializers  
config/initializers/login_attack_report.rb
```ruby
LoginAttackReport.setup do |config|
  # ログイン成功回数リミット
  config.login_ok_limit = 200
  # ログイン失敗回数リミット
  config.login_ng_limit = 50
end
```

## Usage

モデル名をシンボルで渡すことで攻撃性のあるログインを判定します。

前月のログイン成功回数のlimitを超えたユーザを抽出します。  
※ 異常に多い場合、どこかでID/パスワードが漏れている、もしくはIDが共有されている可能性あり
```ruby
    LoginAttackReport::LARVersion.login_ok_limit_over(:User)
```


前月のログイン失敗回数のlimitを超えたユーザを抽出します。  
※ 異常に多い場合、リスト型攻撃を受けている可能性あり
```ruby
    LoginAttackReport::LARVersion.login_ng_limit_over(:User)
```


（未実装）前月のログイン元同一ipのlimitを超えたユーザを抽出します。  
※ 失敗が多く、成功がいくつかあったら、攻撃が成功されている可能性あり
```ruby
    LoginAttackReport::LARVersion.ip_limit_over(:User)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/login_attack_report/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
