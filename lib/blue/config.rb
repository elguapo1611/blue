module Blue
  module Config

    def self.included(klass)
      klass.class_eval do
        @@config = Hashie::Mash.new

        def self.load_config!(new_config = {})
          puts "load_config is deprecated"
          @@config.deep_merge!(new_config)
        end

        def self.configure(new_config = {})
          @@config.deep_merge!(new_config)
        end

        def self.load_app_config!
          load_config!(YAML.load(IO.read(BLUE_CONFIG)))
        end

        def self.config
          @@config
        end

        Blue.configure({
          :user  => 'rails',
          :group => 'rails',
          :scm   => 'git'
        })
      end
    end
  end
end

