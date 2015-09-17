# LocalPostal

Formats addresses using the postal rules of the country it belongs to.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'local_postal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install local_postal

## Usage

The best way to describe how to use this gem is by giving a couple of examples.

```ruby
address = LocalPostal::Address.new(
  name: 'Sherlock Holmes',
  company: '',
  street_address: '221B Baker Street',
  secondary_address: '',
  city: 'London',
  region: 'England',
  postal_code: 'NW1 6XE',
  country: 'United Kingdom'
)

puts address.lines
```

The above will output the following:

    Sherlock Holmes
    221B Baker Street
    LONDON
    England
    NW1 6XE
    UNITED KINGDOM


Here's another example for the US.

```ruby
address = LocalPostal::Address.new(
  name: 'Elwood Blues',
  company: 'The Blues Brothers',
  street_address: '1060 West Addison Street',
  secondary_address: '',
  city: 'Chicago',
  region: 'IL',
  postal_code: '60620',
  country: 'United States'
)

puts address.lines
```

Which will output:

    Elwood Blues
    The Blues Brothers
    1060 West Addison Street
    CHICAGO, IL 60620
    UNITED STATES


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/travishaynes/local_postal.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
