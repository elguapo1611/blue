require 'blue/capistrano/apply'
require 'blue/capistrano/bootstrap'
require 'blue/capistrano/gems'
require "blue/capistrano/integration"
require 'blue/capistrano/local_config'
require 'blue/capistrano/os'
require 'blue/capistrano/packages'
require 'blue/capistrano/rails'
require 'blue/capistrano/ruby'

module Blue
  module Capistrano
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          task :migrate, :roles => [:db] do
            run %(sudo su - blue -c 'cd #{latest_release} && bundle exec rake RAILS_ENV=production db:migrate')
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Capistrano.load(Capistrano::Configuration.instance)
end

