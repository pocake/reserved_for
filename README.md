# ReservedFor

Make word reserved

## Installation

Add this line to your application's Gemfile:

    gem 'reserved_for'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reserved_for

## Usage

### with default username list
`ReservedFor.usernames` is mostly based on [知見 - 登録されるとつらいユーザー名リスト - Qiita](http://qiita.com/phimcall/items/4c559b70f70ea7f1953b)

thanks! @phimcall

```ruby
require 'reserved_for'

# at anywhere
ReservedFor.usernames.include?('index') #=> true
ReservedFor.any.include?('index')       #=> true

ReservedFor.foo_undefined_list.include?('index')       #=> false
```

### set your own reserved list

```ruby
require 'reserved_for'

# removes all reserved-list(including default username list) if you want
ReservedFor.clear_all!
ReservedFor.usernames.empty? #=> true

ReservedFor.your_reserved_list = %w(alice bob)

# at anywhere
ReservedFor.your_reserved_list.include?('alice') #=> true
ReservedFor.any.include?('alice')                #=> true
ReservedFor.any.include?('charlie')              #=> false
```

### String extension
```ruby
require 'reserved_for/string' # instead of require 'reserved_for'

# at anywhere
'index'.reserved_for_usernames? #=> true
'index'.reserved_for_any?       #=> true
'index'.reserved_for?           #=> true (a alias of '#reserved_for_any?')

'not_reserved_word'.reserved_for? #=> false
```

### Whitelist

whitelist affects `ReservedFor.any` and `String#reserved_for_any?`

```ruby
require 'reserved_for'

ReservedFor.clear_all!
ReservedFor.my_list   = %w(a b)
ReservedFor.whitelist = %w(b)

ReservedFor.my_list.include?('b')   #=> true
ReservedFor.whitelist.include?('b') #=> true
ReservedFor.any.include?('b')       #=> false

# you can ignore whitelist temporary
ReservedFor.any(whitelist: false).include?('b')       #=> true

```

### Configure
```ruby
require 'reserved_for'

ReservedFor.configure do |config|
  # use default-list(only .usernames for now) or not
  config.use_default_reserved_list = false # default: true
  config.check_plural              = true  # default: false
  config.case_sensitive            = true  # default: false
end


ReservedFor.usernames.empty?          #=> true

ReservedFor.fruits = %w(apple)
ReservedFor.fruits.include?('apples') #=> true

ReservedFor.fruits.include?('APPLE')  #=> true
ReservedFor.fruits.include?('Apples') #=> true

```


## Contributing

1. Fork it ( http://github.com/pocake/reserved_for/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
