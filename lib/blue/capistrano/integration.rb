module Blue
  class CapistranoIntegration

    def self.load(capistrano_config)
      capistrano_config.load do

        set :ruby_version, Blue.config.ruby.major_version
        set :ruby_patch, Blue.config.ruby.minor_version

        set :application, Blue.config.application
        set :repository,  Blue.config.repository
        set :scm, Blue.config.scm
        set :user, Blue.config.user

        set :keep_releases, Blue.config.keep_releases || 5
        set :normalize_asset_timestamps, false

        set :shared_children, %w(system log pids tmp)

        Blue::Box.boxes.each do |box|
          server box.ip, *box.roles
        end

        namespace :blue do
          task :testing do
            run "echo $(hostname)"
          end

          task :reboot do
            run "sudo reboot"
          end

          task :shutdown do
            run "sudo shutdown -h now"
          end

          desc "Display Blue Configuration"
          task :config do
            require 'pp'
            pp Blue.config
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::CapistranoIntegration.load(Capistrano::Configuration.instance)
end

