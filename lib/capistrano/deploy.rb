module Blue
  class Deploy
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          desc 'Apply the Blue manifest for this application'
          task :apply_manifest, :except => { :no_release => true } do
            current_host = capture("echo $CAPISTRANO:HOST$").strip.gsub('.', '_')
            run "cd #{latest_release} && RAILS_ROOT=#{latest_release} RAILS_ENV=#{Blue.env} sudo bundle exec shadow_puppet #{latest_release}/config/blue/boxes/#{Blue.env}/#{current_host}.rb"
          end

          task :verify_db do
            executing "cd #{latest_release} && RAILS_ENV=#{Blue.env} bundle exec rails runner 'ActiveRecord::Base.connection.execute %q!SELECT 1=1!'"
          end
        end

        after 'deploy:migrate', 'blue:verify_db'
        before 'deploy:create_symlink', 'blue:apply_manifest'
        after "deploy:update", "deploy:cleanup"
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Deploy.load(Capistrano::Configuration.instance)
end

