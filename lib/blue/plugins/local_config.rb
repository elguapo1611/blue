module Blue
  module LocalConfig
    module CapistranoIntegration

      def self.load(capistrano_config)
        capistrano_config.load do

          set :local_config, Blue.config.local_config || []

          namespace :local_config do

            desc <<-DESC
Uploads local configuration files to the application's shared directory for \
later symlinking (if necessary). Called if local_config is set.
            DESC
            task :upload do
              fetch(:local_config).each do |file|
                filename = File.basename(file)
                path = File.dirname(file)
                if File.exist?(file)
                  run "mkdir -p '#{shared_path}/#{path}'" unless path.empty?
                  parent.upload(file, "#{shared_path}/#{path}/#{filename}")
                end
              end
            end

            desc <<-DESC
Symlinks uploaded local configurations into the release directory.
            DESC
            task :symlink do
              fetch(:local_config).each do |file|
                filename = File.basename(file)
                path = File.dirname(file)
                run "mkdir -p '#{latest_release}/#{path}'" unless path.empty?
                run "ls #{latest_release}/#{file} 2> /dev/null || ln -nfs #{shared_path}/#{path}/#{filename} #{latest_release}/#{file}"
              end
            end
          end

          after 'deploy:finalize_update' do
            local_config.upload
            local_config.symlink
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Blue::LocalConfig::CapistranoIntegration.load(Capistrano::Configuration.instance)
end
