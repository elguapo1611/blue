require 'blue/template'
require 'active_support/core_ext'

module Blue
  class Box < Blue::AbstractManifest

    include Blue::Template

    def self.inherited(klass)
      Blue::Box.register(klass)
      klass.add_role(:ruby)
    end

    def self.register(klass)
      boxes << klass
      true
    end

    def self.boxes
      @@boxes ||= Set.new
    end

    def self.load!
      # Dir.glob("#{Blue.rails_root}/config/blue/#{Blue.env}/*.rb").each do |rb|
      #   require rb
      # end
    end

    def self.add_role(role)
      roles << role
      true
    end

    def self.roles
      @roles ||= Set.new
    end

    def roles
      self.class.roles
    end

    def self.ip
      self.const_get(:IP_ADDRESS)
    end

    def self.user_ip
      [Blue.config.user, ip].join('@')
    end

    def self.import(plugin)
      require "blue/#{plugin}"

      module_name = "Blue::#{plugin.to_s.split('/').map(&:titlecase).join('::')}".constantize
      puts "including #{module_name}"
      self.send :include, module_name
    end
  end
end

Blue::Box.import('ntpd')
Blue::Box.import('apt')

