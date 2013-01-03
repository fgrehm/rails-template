# <%= app_const_base %>

## Initial setup

### Without Vagrant

* Install and setup PostgreSQL
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
cp .env.sample .env
bundle install
bundle exec rake db:reset db:setup
```

#### Running the app

`gem install foreman` if it is not installed

`bundle exec foreman start` will fire up a unicorn server at
http://localhost:8080

### With Vagrant (experimental)

Make sure you have Vagrant and VirtualBox installed on your machine, check if you
have the [prerequisites](http://vagrantup.com/v1/docs/nfs.html#prerequisites)
to use NFS Shared Folders with Vagrant and run:

```terminal
script/setup_vagrant
```

#### Running the app

```terminal
[host-machine] $ vagrant ssh
[vagrant-vm]   $ cd /vagrant
[vagrant-vm]   $ foreman start
```

## Setting up production / staging

### Amazon S3 bucket

Create a bucket with `public read` access and enable CORS on it so that [custom fonts get loaded on Firefox](
http://stackoverflow.com/questions/11261805/rails-3-font-face-failing-in-production-with-firefox).

### Heroku

#### Production

```terminal
heroku addons:add memcachier:dev --app <%= app_const_base.underscore %>

heroku labs:enable user-env-compile --app <%= app_const_base.underscore %>

heroku config:add --app <%= app_const_base.underscore %> FOG_PROVIDER=AWS \
       AWS_ACCESS_KEY_ID='<access-key>' \
       AWS_SECRET_ACCESS_KEY='<secret-key>' \
       FOG_REGION='<fog-region>' \
       FOG_DIRECTORY='<bucket-name>' \
       ASSET_SYNC_GZIP_COMPRESSION=true \
       ASSET_SYNC_MANIFEST=false \
       ASSET_SYNC_EXISTING_REMOTE_FILES=keep \
       TZ='America/Sao_Paulo'
```

#### Staging

```
heroku addons:add memcachier:dev --app <%= app_const_base.underscore %>-staging

heroku labs:enable user-env-compile --app <%= app_const_base.underscore %>-staging

heroku config:add --app <%= app_const_base.underscore %>-staging FOG_PROVIDER=AWS \
       AWS_ACCESS_KEY_ID='<access-key>' \
       AWS_SECRET_ACCESS_KEY='<secret-key>' \
       FOG_REGION='<fog-region>' \
       FOG_DIRECTORY='<bucket-name>' \
       ASSET_SYNC_GZIP_COMPRESSION=true \
       ASSET_SYNC_MANIFEST=false \
       ASSET_SYNC_EXISTING_REMOTE_FILES=keep \
       TZ='America/Sao_Paulo'
```
