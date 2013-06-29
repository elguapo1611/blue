module Blue
  class Rails
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :precompile do
            desc "Precompile assets"
            task :assets do
              run "cd #{release_path} && RAILS_ENV=#{Blue.env} RAILS_GROUPS=assets bundle exec rake assets:precompile"
            end
          end
        end

        after 'blue:apply_manifest', 'deploy:migrate'
        # after 'deploy:migrate', 'blue:precompile:assets'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Rails.load(Capistrano::Configuration.instance)
end

