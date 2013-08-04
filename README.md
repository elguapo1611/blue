# Blue

Blue helps you manage your Ruby on Rails deployment.

* Deploy new code
* Install/Update/Restart services

## Installation

I'm not maintaining gems at the moment since Blue, and its plugins are under rapid development.
I am however going to tag releases that should be somewhat stable.  So, for the meantime, please reference those in your Gemfile:

    group :development, :deployment do
      gem 'blue', :git => 'git@github.com:crankharder/blue.git'
    end

Run Bundle:

    $ bundle

## Setup

Blue provides two rake tasks to help initialize your application and then your boxes:

The first task will copy certain configs into place.

    $ rake blue:setup_app

The second task will do several things:
* Copies your current user's ssh keys into place on the remote boxes.
* Adds this remote user to the 'sudo' group
* Gives NOPASSWD to the 'sudo' group.

You will be asked several times to enter your remote password during this step.

    $ rake blue:setup_boxes

Finally, to verify all your boxes you can run this:

    $ cap blue:testing

## Usage

There are two main cap tasks provided/altered by Blue.

'cap deploy' is hooked by Blue in several places, but remains fairly standard.  Deploy code, restart services, migrations, assets, etc...

    $ cap deploy

'cap blue:apply' does most of what 'cap deploy' does, but also maintains system services.
This includes, installation, setup, configuration, monitoring, etc..

    $ cap blue:apply

Both tasks should, in theory, restart all services gracefully (that is, without incurring downtime)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

