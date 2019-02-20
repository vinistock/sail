![dashboard](https://raw.githubusercontent.com/vinistock/sail/master/app/assets/images/sail/sail.png)

[![Maintainability](https://api.codeclimate.com/v1/badges/00ed468acd8b93f66478/maintainability)](https://codeclimate.com/github/vinistock/sail/maintainability) [![Build Status](https://travis-ci.org/vinistock/sail.svg?branch=master)](https://travis-ci.org/vinistock/sail) [![Test Coverage](https://codeclimate.com/github/vinistock/sail/badges/coverage.svg)](https://codeclimate.com/github/vinistock/sail/coverage) [![Gem Version](https://badge.fury.io/rb/sail.svg)](https://badge.fury.io/rb/sail) ![](http://ruby-gem-downloads-badge.herokuapp.com/sail?color=brightgreen&type=total)

# Sail

This Rails engine brings a setting model into your app to be used as feature flags, gauges, knobs and other live controls you may need.

It saves configurations to the database so that they can be changed while the application is running, without requiring a deploy.

Having this ability enables live experiments and tuning to find an application's best setup.

Enable/Disable a new feature, turn ON/OFF ab testing for new functionality, change jobs' parameters to tune performance, you name it.

It comes with a lightweight responsive admin dashboard for searching and changing configurations on the fly.

Sail assigns to each setting a *relevancy score*. This metric is calculated while the application is running and is based on the relative number of times a setting is invoked and on the total number of settings. The goal is to have an indicator of how critical changing a setting's value can be based on its frequency of usage. 

## Contents

1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Populating the database](#populating-the-database)
4. [Searching](#searching)
5. [Manipulating settings](#manipulating-settings-in-the-code)
6. [Localization](#localization)
7. [Contributing](#contributing)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sail'
```

And then execute:
```bash
$ bundle
```

Adding the following line to your routes file will make the dashboard available at <base_url>/sail

```ruby
mount Sail::Engine => '/sail'
```

Running the install generator will create necessary migrations for having the settings in your database.

```bash
$ rails g sail:install
```

When going through a major version upgrade, be sure to check the [changelog] and run the update generator. It will create whatever migrations are needed to move from any other major version to the latest.

```bash
$ rails g sail:update
```

## Configuration

Available configurations and their defaults are listed below

```ruby
Sail.configure do |config|
  config.cache_life_span = 10.minutes     # How long to cache the Sail::Setting.get response for
  config.array_separator = ';'            # Default separator for array settings
  config.dashboard_auth_lambda = nil      # Defines an authorization lambda to access the dashboard as a before action. Rendering or redirecting is included here if desired.
  config.back_link_path = 'root_path'     # Path method as string for the "Main app" button in the dashboard. Any non-existent path will make the button disappear
  config.enable_search_auto_submit = true # Enables search auto submit after 2 seconds without typing
  config.days_until_stale = 60            # Days with no updates until a setting is considered stale and is a candidate to be removed from code (leave nil to disable checks)
  config.enable_logging = true            # Enable logging for update and reset actions. Logs include timestamp, setting name, new value and author_user_id (if current_user is defined)
end
```

A possible authorization lambda is defined below.

```ruby
Sail.configure do |config|
  config.dashboard_auth_lambda = -> { redirect_to("/") unless current_user.admin? }
end
```

## Populating the database

In order to create settings, use the config/sail.yml file (or create your own data migrations).

If the sail.yml file was not created, it can be generated with the current state of the database using the following rake task.

```bash
$ rake sail:create_config_file
```

After settings have been created a first time, they will not be updated with the values in the yaml file (otherwise it would defeat the purpose of being able to configure the application without requiring a deploy).

Removing the entries from this file will cause settings to be deleted from the database.

Settings can be aggregated by using groups. Searching by a group name will return all settings for that group.
```yaml
# Rails.root/config/sail.yml
# Setting name with it's information contained inside
# These values are used for the reset functionality as well

first_setting:
  description: My very first setting
  value: some_important_string
  cast_type: string
  group: setting_group_1
second_setting:
  description: My second setting, this time a boolean
  value: false
  cast_type: boolean
  group: feature_flags
``` 

To clear the database and reload the contents of your sail.yml file, invoke this rake task.

```bash
$ rake sail:load_defaults
```

## Searching

Searching for settings in the dashboard can be done in the following ways:

* By name: matches a substring of the setting's name
* By group: matches all settings with the same group (exact match)
* By cast type: matches all settings with the same cast type (exact match)
* By stale: type 'stale' and get all settings that haven't been updated in X days (X is defined in the configuration)
* By recent: type 'recent X' where X is the number of hours and get all settings that have been updated since X hours ago

## Manipulating settings in the code

Settings can be read or set via their interface. Notice that when reading a setting's value, it will be cast to the appropriate type using the "cast_type" field.

All possible cast types as well as detailed examples of usage can be found in the [wiki].

```ruby
# Get setting value with appropriate cast type
#
# Returns setting value with cast or yields it if passed a block
Sail.get("name")

Sail.get("name") do |setting_value|
  my_code(setting_value)
end

# Set setting value
Sail.set("name", "value")

# Reset setting value (requires the sail.yml file!)
Sail.reset("name")

# Switcher
# This method will take three setting names as parameters
# positive: This is the name of the setting that will be returned if the throttle setting returns true
# negative: This is the name of the setting that will be returned if the throttle setting returns false
# throttle: A setting of cast_type throttle that will switch between positive and negative
#
# return: Value with cast of either positive or negative, depending on the randomized value of throttle 
# Settings positive and negative do not have to be of the same type. However, throttle must be a throttle type setting

Sail.switcher(
  positive: :setting_name_for_true,
  negative: :setting_name_for_false,
  throttle: :throttle_setting_name
)
```

Sail also comes with a JSON API for manipulating settings. It is simply an interface for the methods described above.

```json
GET sail/settings/:name

Response
{
  "value": true
}

PUT sail/settings/:name

Response
200 OK

GET sail/settings/switcher/:positive/:negative/:throttled_by

Response
{
  "value": "Some value that depends on the setting combination passed"
}

Switching to a specific settings profile

PUT sail/profiles/:name/switch

Response
200 OK
```

## Localization

Sail's few strings are all localized for English in [en.yml], making it easy to create translations for the desired languages.

## Contributing

Contributions are very welcome! Don't hesitate to ask if you wish to contribute, but don't yet know how.

Please refer to this simple [guideline].

If you'd like to help Sail become a featured project of [awesome-ruby], please drop a thumbs up in [this pr].

[guideline]: https://github.com/vinistock/sail/blob/master/CONTRIBUTING.md
[wiki]: https://github.com/vinistock/sail/wiki
[awesome-ruby]: https://github.com/markets/awesome-ruby
[this pr]: https://github.com/markets/awesome-ruby/pull/882
[en.yml]: https://github.com/vinistock/sail/blob/master/config/locales/en.yml
[changelog]: https://github.com/vinistock/sail/blob/master/CHANGELOG.md
