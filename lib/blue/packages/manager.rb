module Blue
  module Packages
    module Manager
      extend ActiveSupport::Concern

      included do
        # TODO: Nothing really requires this to be execute before everything else, even though it needs to
        def install_packages
          self.class.packages.each do |pkg|
            package pkg, :ensure => :installed
          end
        end
        recipe :install_packages
      end

      module ClassMethods
        def package_klasses
          @package_klasses ||= []
        end

        def packages
          @packages ||= [
            package_klasses.map(&:packages),
            Blue.config.packages
          ].flatten.compact.uniq.sort
        end

        def commands
          package_klasses.map{|pkg| pkg.commands rescue []}.flatten.uniq + [
            "rm #{Blue::Packages::SETUP_LOCATION}"
          ]
        end

        def templates
          package_klasses.map{|pkg| pkg.templates rescue []}.flatten.uniq
        end

        def push_commands!
          system %(echo '#{commands.join('\n')}' | ssh #{ip} 'cat > #{Blue::Packages::SETUP_LOCATION}')
        end

        def push_templates!
          templates.each do |tmpl|
            system %(scp -q #{tmpl} #{ip}:/tmp/#{tmpl.split('/').last})
          end
        end

        def push_package_list!
          system %(echo 'sudo apt-get install -y #{packages.join(' ')}' | ssh #{ip} 'cat > #{Blue::Packages::INSTALL_LOCATION}')
        end
      end
    end
  end
end

