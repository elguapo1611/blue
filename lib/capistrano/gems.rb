module Blue
  module Gems

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :gems, :roles => [:ruby] do
              run "sudo gem install #{Blue::Gems.required_gems.join(' ')} --no-ri --no-rdoc"
            end
          end
        end
        # before 'deploy:update', 'blue:setup:gems'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Gems.load(Capistrano::Configuration.instance)
end

