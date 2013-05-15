module Blue
  class Deploy
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          desc 'Apply the Blue manifest for this application'
          task :apply_manifest, :except => { :no_release => true } do
            current_host = capture("echo $CAPISTRANO:HOST$").strip.gsub('.', '_')
            run "cd #{latest_release} && RAILS_ROOT=#{latest_release} RAILS_ENV=#{Blue.env} sudo bundle exec shadow_puppet #{latest_release}/cloud/environments/#{Blue.env}/boxes/#{current_host}.rb"
          end
        end

        before 'deploy:create_symlink', 'blue:apply_manifest'
        after "deploy:update", "deploy:cleanup"
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Deploy.load(Capistrano::Configuration.instance)
end

