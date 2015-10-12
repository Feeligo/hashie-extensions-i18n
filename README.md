# Hashie::Extensions::I18n

Makes Hashie properties localizable


## Usage

```ruby
class Greeting < Hashie::Dash
  localizable_property :hello, coerce: String
end

g = Greeting.new(hello: {en: "Hello", it: "Ciao"})
g.localized_hello(:en)
# => "Hello"
g.localized_hello(:it)
# => "Ciao"
g.localized_hello(:fr)
# => nil
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashie-extensions-i18n'
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Feeligo/hashie-extensions-i18n.

