# Countir

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/countir`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'countir'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install countir

## Usage

```ruby
require 'countir'

client = Countir::Client.new(api_key: $YOUR_API_KEY)

# get account code list
client.list_account_codes

# get journal list
client.list_journals(offset: nil, limit: nil)

# post journal
client.post_journal(
  transaction_date: '2016-01-01',
  memo: 'hogehoge',
  entries: [
    { account_code_id: 1,
      debit_or_credit: 'credit',
      price: 100,
    },
    { account_code_id: 2,
      debit_or_credit: 'debit',
      price: 100,
    },
  ]
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/countir. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

