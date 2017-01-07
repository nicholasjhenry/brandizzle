# Brandizzle

## About

Brandizzle is a social brand monitoring application, based on the "BDDCasts Screencast Series":http://bddcasts.com/series/brandizzle. This application is built using Rails 3 and RSpec 2, where as the screencast uses Rails 2 and RSpec 1.

Please note, this is an application used for practice and is not used in production. However, you may find it useful for as an example of an application developed usuing an "outside-in" approach.

## Testing

The test suite uses the following components:

* RSpec
* Cucumber
* Spork
* Borne
* Factory Girl

Brandizzle is setup with Spork to speed up the BDD cycle. To start the servers:

    bundle exec spork
    bundle exec spork cucumber

TODO: Add note about just running tests (i.e. not continuously)

To run the tests in a continuously, execute:

    autotest -- --skip-bundler

TODO: Add a standard method for cucumber. See https://github.com/guard/guard-cucumber

To generate RSpec documentation:

    rspec spec/ --format documentation

To run code metrics:

    metrical

To run test coverage (exit Spork for RSpec and Cucumber while running as you will get no output):

    rake cover_me:all
