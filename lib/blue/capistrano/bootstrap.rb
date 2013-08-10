module Blue
  class Bootstrap
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          # This task should be idempotent
          desc "Configures generic dependencies Blue depends on"
          task :bootstrap do
            blue.setup.packages
            blue.setup.ruby
            blue.setup.gems
            blue.setup.user
            blue.setup.github
            blue.setup.directory
            deploy.setup
            blue.reboot unless ENV['NOREBOOT']
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Bootstrap.load(Capistrano::Configuration.instance)
end

