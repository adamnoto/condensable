# Condensable
ba0907e0-5c16-0133-cf88-42612c8c8541

[ ![Codeship Status for saveav/condensable](https://codeship.com/projects/ba0907e0-5c16-0133-cf88-42612c8c8541/status?branch=release)](https://codeship.com/projects/110913)

In chemistry, condensation is the process of vapour or gas to become a liquid. But,
this is no chemistry things. Here, condensable is describing a condition of a class
that allow to make itself respond to getter and setter routines when they are not 
(yet) defined.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'condensable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install condensable

## Usage

Simple enough, just include `Condensable` into your class and you are set.

```ruby
class OrderParams
  include Condensable
end
```

And, you can use your condensable instance as follow:

```ruby
order = OrderParams.new
order.order_id = 12
order.customer = "Adam Pahlevi Baihaqi"
```

Notice that both `order_id` and `customer` have not yet been defined, but a condensable
class would automatically define that on-demand.

### Specifying default condensation behaviour

By default, when a getter is not available, a condensable instance will return nil:

```ruby
order.shipping_address == nil # true
```

To alter the default behaviour, specify `condensable default` in your class, like below:

```ruby
class OrderParams
  include Condensable

  condensable default: "not-available"
end
```

Therefore, when invoked:

```
order.shipping_address
```

It will returns `not-available`.

There are 4 condensation behaviours:

1. Returning nil (`condensable default: nil`)
2. Returning string (`condensable default: "some string"`)
3. Executing a method, by always passing a symbol (`condensable default: :execute_method`)
4. Raising an error (`condensable default: :raise_error`)

For more details, please see the spec which demonstrates the all four.

## License

The gem is proudly available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
