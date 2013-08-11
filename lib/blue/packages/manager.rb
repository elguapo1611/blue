module Blue
  module Packages
    class Manager

      attr_accessor :klass
      def initialize(klass)
        @klass = klass
      end

      def klasses
        @klasses ||= ::Set.new
      end

      def objects
        klasses.map{|k| k.new(klass)}
      end

      def packages
        [
          objects.map(&:packages),
          Blue.config.packages
        ].flatten.compact.uniq.sort
      end

      def commands
        objects.map{|obj| obj.commands rescue []}.flatten.uniq + [
          "rm #{Blue::Packages::SETUP_LOCATION}"
        ]
      end

      def templates
        objects.map{|obj| obj.templates rescue []}.flatten.uniq
      end

      def push_commands!
        system %(echo '#{commands.join('\n')}' | ssh #{klass.cap_user_ip} 'cat > #{Blue::Packages::SETUP_LOCATION}')
      end

      def push_templates!
        templates.each do |tmpl|
          system %(scp -q #{tmpl} #{klass.cap_user_ip}:/tmp/#{tmpl.split('/').last})
        end
      end

      def push_package_list!
        system %(echo 'sudo apt-get install -y #{packages.join(' ')}' | ssh #{klass.cap_user_ip} 'cat > #{Blue::Packages::INSTALL_LOCATION}')
      end
    end
  end
end

