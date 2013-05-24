module Blue
  module Config

    def self.included(klass)
      klass.class_eval do
        @@config = Hashie::Mash.new

        def self.configure(new_config = {})
          @@config.deep_merge!(new_config)
        end

        def self.load_app_config!
          configure(YAML.load(IO.read(BLUE_CONFIG)))
        end

        def self.config
          @@config
        end

        Blue.configure({
          :user  => 'rails',
          :group => 'rails',
          :scm   => 'git',
          :prod_safe_ip_addresses => []
        })
      end
    end
  end
end

