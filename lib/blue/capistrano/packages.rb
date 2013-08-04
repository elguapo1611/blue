module Blue
  module Capistrano
    class Packages

      def self.load(capistrano_config)
        capistrano_config.load do
          namespace :blue do
            namespace :packages do

              task :setup do
                run "sudo dpkg --configure -a"
                Blue::Packages.push!
                blue.packages.execute_commands
                blue.packages.update
              end

              task :bootstrap do
                blue.packages.setup
                run "sudo apt-get -y dist-upgrade"
                blue.packages.install
              end

              task :update do
                run "sudo apt-get update"
              end

              task :install do
                run "sh #{Blue::Packages::INSTALL_LOCATION}"
              end

              task :execute_commands do
                run "sh #{Blue::Packages::SETUP_LOCATION}"
              end
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Capistrano::Packages.load(Capistrano::Configuration.instance)
end

