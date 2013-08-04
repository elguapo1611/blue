module Blue
  class AbstractManifest < ShadowPuppet::Manifest

    def execute_with_set_current!(*args)
      self.class.current!
      Blue::Plugins.setup!
      execute_without_set_current!(*args)
    end
    alias_method_chain :execute!, :set_current

    def self.hostname
      self.const_defined?(:HOSTNAME) ? self.const_get(:HOSTNAME) : self.name.underscore.gsub("_", '.')
    end

    def self.roles
      self.const_get(:ROLES)
    end
  end
end

