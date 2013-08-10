module Blue
  class Apply
    def self.load(capistrano_config)
      capistrano_config.load do

        namespace :blue do
          desc 'Apply the Blue manifest for this application'
          task :apply, :except => { :no_release => true } do
            blue.setup.directory
            deploy.update_code
            shadow_puppet_cmd = %(cd #{latest_release} && RAILS_ROOT=#{latest_release} RAILS_ENV=#{Blue.env} bundle exec shadow_puppet #{latest_release}/config/blue/#{Blue.env}/${HOSTNAME//[-\\.]/_}.rb)
            run %(sudo su - -c '#{shadow_puppet_cmd}')
            deploy.create_symlink
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::Apply.load(Capistrano::Configuration.instance)
end

