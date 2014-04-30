# ar-random

ar-random is a ruby gem that efficiently selects random records from the database, avoiding the inefficient "ORDER BY RANDOM()"

Requires ActiveRecord >= 3.0.0 and supports SQLite, MySQL and Postgres/PostGIS

## Install

``` ruby
# Add the following to you Gemfile
gem 'ar-random'

# Update your bundle
bundle install
```

## Usage

Simply chain .random into your existing relation scopes

``` ruby
Item.random # a random Item is returned if it exists, otherwise nil
```

### How It Works

ar-random selects the maximum and minimum primary key in the scope, and retrieves the first record >= a randomly generated number within the range of ids.

For example, if the scoped range returns min(id) = 12393882 and max(id) = 39845743, a randomly generated number might be 29812874.  A record id >= 29812874 would then be selected from the database.

## Performance

ar-random was created out of a need to eliminate "ORDER BY RANDOM()" queries for large datasets.  However, since multiple queries are issued to the database, for smaller datasets the simpler "ORDER BY RANDOM()" approach is typically more efficient.
