module Blue
  class Rails
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          desc "Precompile assets"
          task :precompile_assets do
            run "cd #{latest_release} && RAILS_ENV=#{Blue.env} RAILS_GROUPS=assets bundle exec rake assets:precompile"
            run "cd #{latest_release} && chown -R :blue public/assets"
          end

          desc "Verifies the environment and connection to the DB"
          task :verify_db do
            run %(sudo su - blue -c "cd #{latest_release} && RAILS_ENV=#{Blue.env} bundle exec rails runner 'ActiveRecord::Base.connection.execute %q!SELECT 1=1!'")
          end
        end

        before 'deploy:create_symlink', 'blue:migrate'
        after 'blue:migrate', 'blue:precompile_assets'
        before 'blue:migrate', 'blue:verify_db'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Rails.load(Capistrano::Configuration.instance)
end

