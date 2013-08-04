module Blue
  class Os

    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :setup do
            desc "Install required gems"
            task :packages do
              blue.packages.bootstrap
            end

            desc "Create blue user"
            task :user do
              cmd = [
                "sudo useradd -m -s /bin/bash blue",
                "sudo mkdir /home/blue/.ssh",
                "sudo cp /home/#{Blue.config.user}/.ssh/id_rsa.pub /home/blue/.ssh/authorized_keys",
                "sudo chown -Rf blue:blue /home/blue/.ssh",
                "sudo usermod -a -G blue #{Blue.config.user}"
              ].join(' && ')
              run "test -d /home/blue || (#{cmd})"
            end

            desc "Setup privileges on the app directory"
            task :directory do
              run "sudo mkdir -p /u/apps/#{application}"
              run "sudo chown -Rf #{Blue.config.user}:blue /u/apps/#{application}"
              run "sudo sudo chmod -Rf 770 /u/apps/#{application}"
            end
            before 'deploy:setup', 'blue:setup:directory'
            after 'deploy:update_code', 'blue:setup:directory'

            desc "Setup github public key"
            task :github do
              # Grab github's fingerprint
              # Oh yea, this is dangerous
              run "ssh -o StrictHostKeyChecking=no git@github.com || true"
            end

          end
        end

        after "deploy:update", "deploy:cleanup"
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Os.load(Capistrano::Configuration.instance)
end

