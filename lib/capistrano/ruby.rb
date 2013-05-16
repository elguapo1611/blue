module Blue
  class RubyInstall

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install Ruby 1.9.3"
            task :ruby do
              version = "ruby-#{Blue.config.ruby.major_version}-p#{Blue.config.ruby.minor_version}"

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

              run "test -x /usr/bin/ruby && test #{Blue.config.ruby.major_version}p#{Blue.config.ruby.minor_version} = $(ruby --version | awk '{print $2}') || (#{cmd})"
            end
          end
        end
      end
    end
  end
end

Blue.configure!({
  :ruby  => {
    :major_version => '1.9.3',
    :minor_version => '429'
  }
})

if Capistrano::Configuration.instance
  Blue::RubyInstall.load(Capistrano::Configuration.instance)
end

