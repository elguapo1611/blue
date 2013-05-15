module Blue
  class Os
    PACKAGES = %w(
      build-essential
      zlib1g-dev
    )

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :os do
              sudo "apt-get install -y #{Blue::Os::PACKAGES.join(' ')}
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Os.load(Capistrano::Configuration.instance)
end

