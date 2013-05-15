module Blue
  class Setup
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          # This task should be idempotent
          desc "Configures generic dependencies Blue depends on"
          task :install, :roles => [:ruby] do
            blue.setup.os
            blue.setup.ruby
            blue.setup.gems
          end
        end
        after 'deploy:setup', 'blue:install'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Setup.load(Capistrano::Configuration.instance)
end

require 'capistrano/os'
require 'capistrano/ruby'
require 'capistrano/gems'
