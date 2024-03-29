Blue helps you manage your Ruby on Rails deployment.

* Deploy new code
* Install/Update/Restart services

### Operating Systems

Currently, we only support Ubuntu 12.04 LTS.

### Installation

I'm not maintaining gems at the moment since Blue, and its plugins are under rapid development.
I am however going to tag releases that should be somewhat stable.  So, for the meantime, please reference those in your Gemfile:

    group :development, :deployment do
      gem 'blue', :git => 'git@github.com:crankharder/blue.git', :tag => 'v0.6'
    end

Run Bundle:

    $ bundle

### Setup

Blue provides two rake tasks to help initialize your application and then your boxes:

The first task will copy certain configs into place.

    $ rake blue:setup_app

The second task will do several things:
* Copies your current user's ssh keys into place on the remote boxes.
* Adds this remote user to the 'sudo' group
* Gives NOPASSWD to the 'sudo' group.

You will be asked several times to enter your remote password during this step.

    $ rake blue:setup_boxes

At this point, you should run this, which will verify a few things required to move forward.

    $ cap blue:testing

If there are no errors, then you're ready to go ahead and boostrap your boxes.

    $ cap blue:bootstrap

This task will update your boxes, install required system packages and install ruby.

### Usage

There are two main cap tasks provided/altered by Blue.

'cap deploy' is hooked by Blue in several places, but remains fairly standard.  Deploy code, restart services, migrations, assets, etc...

    $ cap deploy

'cap blue:apply' does most of what 'cap deploy' does, but also maintains system services.
This includes, installation, setup, configuration, monitoring, etc..

    $ cap blue:apply

Both tasks should, in theory, restart all services gracefully (that is, without incurring downtime)

### Plugins
Blue was built with the intention of having plugins sit along side it.
By itself, Blue doesn't do much.  It will prep your boxes, hook capistrano and clone your repo... but that's about it.
If you want to run an application, you'll need some plugins.

* [nginx](https://github.com/crankharder/blue-nginx) - HTTP server.
* [unicorn](https://github.com/crankharder/blue-unicorn) - App Server
* [postgresql](https://github.com/crankharder/blue-postgresql) - Database
* [redis](https://github.com/crankharder/blue-redis) - Key/Value Store
* [resque](https://github.com/crankharder/blue-resque) - Background Workers
* [resque_scheduler](https://github.com/crankharder/blue-resque_scheduler) - Cron for Resque
* [icinga](https://github.com/crankharder/blue-icinga) - Monitoring

### Testing

Uh, Blue has no tests... Think it should? Great! Want to write some?

I've been using a test app to help build Blue.  It's relatively simple: A web server, two app servers and a db server.  Have a look [here](https://github.com/crankharder/blue-test-app)

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

