require 'blue/template'
require 'active_support/core_ext'

module Blue
  class Box < Blue::AbstractManifest

    include Blue::Template
    include Blue::Ntpd

    def self.inherited(klass)
      Blue.register_box(klass)
      klass.add_role(:ruby)
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

    def self.import(plugin)
      require "blue/#{plugin}"

      module_name = "Blue::#{plugin.to_s.split('/').map(&:titlecase).join('::')}"
      puts "requiring #{module_name}"
      self.send :include, module_name #"Blue::#{plugin.to_s.split('/').map(&:titlecase).join('::')}"
    end
  end
end

