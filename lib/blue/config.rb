module Blue
  module Config
    extend ActiveSupport::Concern

    included do
      Blue.configure({
        :user  => 'rails',
        :group => 'rails',
        :scm   => 'git',
        :prod_safe_ip_addresses => []
      })
    end

    module ClassMethods
      def configure(new_config = {})
        @@config ||= Hashie::Mash.new
        @@config.deep_merge!(new_config)
      end

      def load_app_config!
        configure(YAML.load(IO.read(BLUE_CONFIG)))
      end

      def config
        @@config
      end

    end

    def self.verify!
      Blue::Box.boxes.each do |box|
        box.name != 'SomeHostnameCom' || verify_error("Rename the file/class SomeHostnameCom to something else")
        box.const_get(:IP_ADDRESS).present? rescue verify_error("#{box}::IP_ADDRESS needs to be defined")
        box.const_get(:HOSTNAME).present? rescue verify_error("#{box}::HOSTNAME needs to be defined")
      end
      puts "Successfully verified Blue config!"
    end

    def self.verify_error(msg)
      puts msg
      exit 1
    end
  end
end

