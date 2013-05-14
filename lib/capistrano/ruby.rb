module Blue
  class RubyInstall
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install Ruby 1.9.3"
            task :ruby do
              version = "ruby-#{fetch(:ruby_version)}-p#{fetch(:ruby_patch)}"

              cmd = [
                'sudo apt-get install autoconf libyaml-dev -y || true',
                'cd /tmp',
                "sudo rm -rf #{version}* || true",
                "wget -q http://ftp.ruby-lang.org/pub/ruby/#{version}.tar.gz",
                "tar zxvf #{version}.tar.gz",
                "cd /tmp/#{version}",
                "./configure --prefix=/usr",
                "make",
                "sudo make install"
              ].join(' && ')

              run "test #{fetch(:ruby_version)}p#{fetch(:ruby_patch)} = $(ruby --version | awk '{print $2}') || (#{cmd})"
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::RubyInstall.load(Capistrano::Configuration.instance)
end

