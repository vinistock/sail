[![Maintainability](https://api.codeclimate.com/v1/badges/00ed468acd8b93f66478/maintainability)](https://codeclimate.com/github/vinistock/sail/maintainability) [![Build Status](https://travis-ci.org/vinistock/sail.svg?branch=master)](https://travis-ci.org/vinistock/sail) [![Test Coverage](https://codeclimate.com/github/vinistock/sail/badges/coverage.svg)](https://codeclimate.com/github/vinistock/sail/coverage) [![Gem Version](https://badge.fury.io/rb/sail.svg)](https://badge.fury.io/rb/sail) ![](http://ruby-gem-downloads-badge.herokuapp.com/sail?color=brightgreen&type=total)

# Sail

A gem to bring into your Rails application settings to be used as knobs and gauges for controlling behavior. 

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sail'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sail
```

Running the generator will create the settings table for your application.

```bash
$ rails g sail my_desired_migration_name
```

Which generates a migration to create the following table

```ruby
create_table :sail_settings do |t|
  t.string :name, null: false
  t.text :description
  t.string :value, null: false
  t.integer :cast_type, null: false, limit: 2
  t.index ["name"], name: "index_settings_on_name", unique: true
end
```

## Manipulating settings in the code

Settings can be read or set via their interface. Notice that when reading a setting's value, it will be cast to the appropriate type using the "cast_type" field.

Possible cast types are
* integer
* string
* boolean
* range
* array

```ruby
# Get setting value with appropriate cast type 
Setting.get('name')

# Set setting value
Setting.set('name', 'value') 
```

## Examples

```ruby
# Integer setting
Setting.create(name: :my_setting, cast_type: :integer, description: 'A very important setting', value: '15')
Setting.get(:my_setting)
=> 15

# String setting
Setting.create(name: :my_setting, cast_type: :string, description: 'A very important setting', value: '15')
Setting.get(:my_setting)
=> '15'

# Boolean setting
Setting.create(name: :my_setting, cast_type: :boolean, description: 'A very important setting', value: 'true')
Setting.get(:my_setting)
=> true

# Range setting (ranges only accept values between 0...100)
Setting.create(name: :my_setting, cast_type: :range, description: 'A very important setting', value: '99')
Setting.get(:my_setting)
=> 99

# Array setting
Setting.create(name: :my_setting, cast_type: :array, description: 'A very important setting', value: 'John;Alfred;Michael')
Setting.get(:my_setting)
=> ['John', 'Alfred', 'Michael']
```
