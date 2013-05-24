require 'blue/template'

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

    def self.import(klass)
      require klass.name.underscore
      include klass
    end
  end
end

