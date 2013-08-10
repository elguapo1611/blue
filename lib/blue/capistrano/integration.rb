module Blue
  class CapistranoIntegration

    def self.load(capistrano_config)
      capistrano_config.load do

        set :ruby_version, Blue.config.ruby.major_version
        set :ruby_patch, Blue.config.ruby.minor_version

        set :application, Blue.config.application
        set :repository,  Blue.config.repository
        set :branch, Blue.config.branch || 'master'
        set :scm, Blue.config.scm || 'git'
        set :user, Blue.config.user

        set :keep_releases, Blue.config.keep_releases || 5
        set :normalize_asset_timestamps, false

        set :shared_children, %w(system log pids tmp)

        Blue::Box.boxes.each do |box|
          server box.cap_user_ip, *(box.roles + [box.migrations? ? :db : nil]).to_a.compact, :primary => box.migrations?
        end

        namespace :blue do
          task :testing do
            run "sudo echo $(hostname): $(uptime)"
          end

          task :reboot do
            run "sudo reboot"
          end

          task :shutdown do
            run "sudo shutdown -h now"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::CapistranoIntegration.load(Capistrano::Configuration.instance)
end

