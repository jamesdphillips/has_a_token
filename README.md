# HasAToken

Generate simple/complex/readable tokens in Rails models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_a_token'
```

And then execute:

    $ bundle

## Usage
Charsets include: `:unambiguous`, `:alphabetical`, and the default `urlsafe_base64`

Basic usage:

```ruby
# Setup your model
class User < ActiveRecord::Base
  include HasAToken::Concern

  # ...

  has_a_token :invite_code, charset: :unambiguous # generates an easily readable token
  has_a_token :password_reset, length: 32 # generates a 32 character secure token

  # ...

  # You can use the generate_* methods to fetch a token when records are created
  before_create :generate_invite_code
  before_save :generate_password_reset_token, if: "password_reset_token.nil?"

  # ...
end

# Reset a token
user = User
user.reset_password_reset_token! # creates a new token and persists the changes
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/has_a_token/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Tests

You can run the tests using the `rake test` command.
