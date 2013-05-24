module Blue
  class Gems

    @@required_gems = [
      'bundler',
      'shadow_puppet',
      'blue',
      'rake',
      'builder'
    ]

    def self.required_gems
      @@required_gems
    end

    def self.require(gem)
      @@required_gems << gem
    end

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :gems do
              sudo "gem install #{Blue::Gems.required_gems.join(' ')} --no-ri --no-rdoc"
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

