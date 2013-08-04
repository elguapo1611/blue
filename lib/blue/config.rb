module Blue
  module Config
    extend ActiveSupport::Concern

    module ClassMethods
      def configure(new_config = {})
        config.deep_merge!(new_config)
      end

      def config
        @config ||= Hashie::Mash.new
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

