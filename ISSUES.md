Currently hacking in place (in an unsafe way) the github key fingerprint, or else the first git clone fails.

Postgres notes:
sudo apt-get install libpq-dev # required for gem 'pg'
will need to use puppet/shaddow_puppet from root install (not bundler) as they'll need to be available to install postgres/dependencies before the gem 'pg' can be installed

