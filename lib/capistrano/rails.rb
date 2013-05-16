module Blue
  class Rails
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          namespace :db do
            desc "Install required gems"
            task :migrate do
              run "cd #{Blue.current_release_dir} && RAILS_ENV=#{Bundle.env} bundle exec rake db:migrate"
            end
          end
        end

        after 'blue:apply_manifest', 'blue:db:migrate'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Rails.load(Capistrano::Configuration.instance)
end

