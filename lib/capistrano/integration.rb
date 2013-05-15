module Blue
  class CapistranoIntegration

    def self.load(capistrano_config)
      capistrano_config.load do

        set :ruby_version, Blue.config.ruby.try(:version) || '1.9.3'
        set :ruby_patch, Blue.config.ruby.try(:patch) || '429'

        set :application, Blue.config.application
        set :repository,  Blue.config.repository
        set :scm, Blue.config.scm || 'git'
        set :user, Blue.config.user || 'rails'

        set :keep_releases, Blue.config.keep_releases || 5
        set :normalize_asset_timestamps, false

        set :shared_children, %w(system log pids tmp)

        Blue.boxes.each do |box|
          server box.hostname, *box.roles
        end

        namespace :blue do
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

