module Blue
  class Gems
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :gems do
              sudo "gem install bundler --no-ri --no-rdoc"
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Gems.load(Capistrano::Configuration.instance)
end

