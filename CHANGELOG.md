## 3.5.0 ##

### UI refactors

* Make cards smaller and add flip functionality. Descriptions are now in the back
* Shift to using flex attributes where possible
* Remove monitor mode
* Make number of settings per page 20
* Create config/sail.yml in install generator

*[@vinistock]*

## 3.4.0 ##

* Remove support for Rails 4

*[@vinistock]*

* Fix font aliasing in Firefox

*[@vinistock]*

* Fix details marker not disappearing in Firefox

*[@vinistock]*

* Fix pagination links for a single page display

*[@vinistock]*

* Use css only instead of scss and drop sassc-rails dependency

*[@vinistock]*

## 3.3.0 ##

* Fix caching issue with settings pagination 

*[@asko-ohmann]*

* Preserve query parameters in pagination links

*[@oleg-kiviljov]*

* Start displaying a limited sliding number of links in pagination

*[@vinistock]*

* Add GraphQL support for fetching settings

*[@vinistock]*

* Add deprecation warning for Rails 4. The next major version of Sail will support Rails > 5

*[@vinistock]*

* Add GraphQL mutations for updating settings and switching profiles

*[@vinistock]*

## 3.2.4 ##

* Fix migration generation for Rails 6

*[@vinistock]*

* Fix stale label position for xs screens

*[@vinistock]*

* Start displaying the update and failure alerts inside the setting cards

*[@vinistock]*

* Add Set setting type

*[@vinistock]*

## 3.2.3 ##

* Start displaying the count of uncaught errors while a profile is active

*[@vinistock]*

* Fix Sail::Setting.get caching

*[@oleg-kiviljov]*

## 3.2.2 ##

* Properly set the locale for localization

*[@vinistock]*

* Hide guide sections that are not being viewed

*[@vinistock]*

* Fix font styling issues

*[@vinistock]*

* Fix styling issues on inputs and links for Safari desktop and mobile

*[@vinistock]*

## 3.2.1 ##

* Fix responsive layout for profiles modal, sort menu, search input and buttons

*[@vinistock]*

* Fix setting N+1 query in profiles modal

*[@vinistock]*

* Fix profile updates not saving entries

*[@vinistock]*

* Fix input UI style after resetting date settings

*[@vinistock]*

* Fix accessing devise's current user for logging

*[@vinistock]*

## 3.2.0 ##

* Use Rails environment instead of manually initializing applications for rake tasks

*[@chaadow]*

* Add expected_errors and auto reset for Sail.get

*[@vinistock]*

* Make Sail.get with block return the block result instead of the setting value

*[@vinistock]*

## 3.1.0 ##

* Add tooltips for guide sections

*[@vinistock]*

* Create locales setting type

*[@vinistock]*

* Make engine compatible with Rails API only mode

*[@vinistock]*

* Add monitor mode to dashboard displaying minimalistic cards

*[@vinistock]*

* Fix dynamic setting types being incorrectly cached

*[@vinistock]*

* Add reference guide to dashboard containing usage instructions

*[@vinistock]*

* Expire cache fragments after 500 new usages of each setting
  so that the relevancy score actually updates.
  
*[@vinistock]*  

## 3.0.1 ##

* Initialize Rails application when running rake tasks (bug)

*[@vinistock]*

* Change cache life span to 6 hours

*[@vinistock]*

## 3.0.0 ##

There are some breaking changes in this new major version. Please read through the changelog and execute the update generator to create the necessary migrations.

```bash
$ rails g sail:update
```

* Enhance sort menu placement for responsive layouts

*[@vinistock]*

* Add active profile indicators

*[@vinistock]*

* Reload page after profile switching

*[@vinistock]*

* Create rake task to export database settings to config file

*[@vinistock]*

* Allow Sail.get to be used with a block. Start yielding setting value to passed block.

*[@vinistock]*

* Create update generator to assist user upgrading major versions

*[@vinistock]*

* Add profiles with API and modal
  - Creating, updating, deleting and switching profiles
  - API for switching in JSON
  - All operations implemented as part of the dashboard

In order to create profiles in the application, run the update generator. Even if upgrading from 1.x.x (generator will detect current state of the database and add the appropriate migrations).

```bash
$ rails g sail:update
```

Or create the migration manually.

```ruby
class CreateSailProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :sail_entries do |t|
      t.string :value, null: false
      t.references :setting, index: true
      t.references :profile, index: true
      t.timestamps
    end

    create_table :sail_profiles do |t|
      t.string :name, null: false
      t.boolean :active, default: false
      t.index ["name"], name: "index_sail_profiles_on_name", unique: true
      t.timestamps
    end

    add_foreign_key(:sail_entries, :sail_settings, column: :setting_id)
    add_foreign_key(:sail_entries, :sail_profiles, column: :profile_id)
  end
end
```

*[@vinistock]*

* Add relevancy score to settings

*[@vinistock]*

## 2.1.1 ##

* Fix image URLs in css

*[@vinistock]*

## 2.1.0 ##

* Add stale labels to settings older than the configured number of days

*[@vinistock]*

* Add stale links and searching capabilities

*[@vinistock]*

* Fix gray background in reset button for Firefox

*[@vinistock]*

* Fix range slider positioning for Firefox

*[@vinistock]*

* Lighten text input gray colors

*[@vinistock]*

* Add the capability of searching for recently updated settings

*[@vinistock]*

* Prevent errors if the database has not been created yet

*[@vinistock]*

* Drop Ruby 2.2.x support

*[@vinistock]*

* Add logging for update and reset actions

*[@vinistock]*

* Add sorting functionality to the dashboard

*[@vinistock]*

* Update the reset icon

*[@vinistock]*

* Ensure SettingsController inherits from the correct ApplicationController

*[@johnthethird]*

* Update pagination icons

*[@vinistock]*

* Refactor and move main app icon to the search portion of the dashboard

*[@vinistock]*

## 2.0.0 ##

### Regular changes ###

* Fix search bar size changing during focus bug

*[@vinistock]*


* Add capability to search by cast type

*[@vinistock]*

* Change multiple small style details

*[@vinistock]*

* Add search auto submit

*[@vinistock]*

* Add reset button functionality

*[@vinistock]*

* Add load_defaults rake task

*[@vinistock]*

### Breaking changes ###

The addition of group to settings requires a migration if you're upgrading from older versions.

```ruby
class AddGroupToSailSettings < ActiveRecord::Migration[5.2]
  def change
    add_column(:sail_settings, :group, :string)
  end
end
```

* Add group to settings

*[@vinistock]*

* Add capability to search by group

*[@vinistock]*

* Add group and cast type links

*[@vinistock]*

## 1.5.1 ##

* Fix Ruby 2.2.x errors

*[@vinistock]*

* Start deleting settings removed from the YAML file from the database

*[@vinistock]*

* Add simplified interface via module

*[@vinistock]*

## 1.5.0 ##

* Create throttle setting type

*[@vinistock]*

* Create new switcher method to randomly swap between two settings

*[@vinistock]*

* Created JSON API for switcher

*[@vinistock]*

* Refactor layout including update and failure messages

*[@vinistock]*

* Add Rails 4 support

*[@vinistock]*

* Fix errors related to populating the database via YAML file before running migrations

*[@vinistock]*

## 1.4.2 ##

* Fix bug where an undefined number of pages would prevent access to the dashboard

*[@vinistock]*

## 1.4.1 ##

* Replace old migration generator with simpler installer

*[@vinistock]*

* Added YAML configuration file for populating the database

*[@vinistock]*

* Moved main app button string to localization file

*[@vinistock]*

## 1.4.0 ##

* Add date picker for date settings

*[@vinistock]*

* Create URI setting type

*[@vinistock]*

* Add configurable link to refer back to main app

*[@vinistock]*

## 1.3.0 ##

* Fix bug when trying to save Boolean settings as false

*[@vinistock]*

* Fix migration being generated with incorrect name

*[@vinistock]*

* Fix missing attribute errors for query scope

*[@vinistock]*

* Remove jquery and use pure javascript

*[@vinistock]*

* Start loading javascript async

*[@vinistock]*

* Add date and model setting types

*[@rohandaxini]*

## 1.2.2 ##

* Add dashboard authorization lambda

*[@vinistock]*

## 1.2.1 ##

* Fix Setting.get behavior for missing settings

*[@vinistock]*

## 1.2.0 ##

* Add A/B setting type

*[@vikasnautiyal]*

* Add cron setting type

*[@vinistock]*

* Add dashboard setting search

*[@vinistock]*

* Make style updates to dashboard

*[@AndyRosenberg]*

* Expose show and update JSON APIs for settings

*[@zvlex]*

* Start displaying "Failed" message for unsuccessful updates

*[@vinistock]*

## 1.1.0 ##

* Add gem configuration

*[@vinistock]*

* Add float setting type

*[@vinistock]*

* Improve dashboard UI

*[@vinistock]*

## 1.0.1 ##

* Reduce cast_type limit to 1

*[@vinistock]*

## 1.0.0 ##

* First release with basic functionality

[@vinistock]: https://github.com/vinistock
[@vikasnautiyal]: https://github.com/vikasnautiyal
[@AndyRosenberg]: https://github.com/AndyRosenberg
[@zvlex]: https://github.com/zvlex
[@rohandaxini]: https://github.com/rohandaxini
[@johnthethird]: https://github.com/johnthethird
[@chaadow]: https://github.com/chaadow
