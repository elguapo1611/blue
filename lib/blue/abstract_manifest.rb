module Blue
  class AbstractManifest < ShadowPuppet::Manifest

    def self.inherited(klass)
      unless klass == Blue::Box
        raise StandardError, "Do not inherit directly from #{self.class.name}. Instead, inherit from #{Blue::Box}"
      end
    end

    def self.hostname
      self.const_defined?(:HOSTNAME) ? self.const_get(:HOSTNAME) : self.name.underscore.gsub("_", '.')
    end

    def self.roles
      self.const_get(:ROLES)
    end

    def self.__config__
      ShadowPuppet::Manifest.__config__
    end

    def self.recipes
      ShadowPuppet::Manifest.recipes
    end
  end
end

