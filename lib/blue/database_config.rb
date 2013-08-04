module Blue
  module DatabaseConfig
    include Blue::Plugin

    included do
      configure(
        :database => YAML::load(IO.read(Blue::DatabaseConfig.database_yml))[Blue.env]
      )
    end

    def self.database_yml
      File.join(Blue::Box.current_release_dir, 'config', 'database.yml')
    end
  end
end

