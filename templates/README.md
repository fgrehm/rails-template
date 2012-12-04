# <%= app_const_base %>

## Initial setup

* Setup PostgreSQL
  * Ubuntu
    * http://socrateos.blogspot.com.br/2012/08/installing-postgresql-91-on-ubuntu-1204.html
    * https://help.ubuntu.com/community/PostgreSQL
    * `sudo apt-get install libpq-dev`
* [Install Phantom.js](http://phantomjs.org/download.html) for running JS and
  integration specs
* Make sure you have required libraries for installing [nokogiri](http://nokogiri.org)
  (used by Capybara)
  * Ubuntu -> `sudo apt-get install libxslt-dev libxml2-dev`
* Run:

```terminal
cp config/database.yml.sample config/database.yml
bundle install
bundle exec rake db:reset db:setup
```
