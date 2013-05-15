module Blue
  class Os
    PACKAGES = %w(
      g++ gcc make libc6-dev patch openssl ca-certificates libreadline6 \
      libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev \
      libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev \
      libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
    )

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :os do
              sudo "apt-get install -y #{Blue::Os::PACKAGES.join(' ')}"
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

