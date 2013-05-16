module Blue
  module DatabaseConfig

    def self.database_yml
      File.join(Blue.current_release_dir, 'config', 'database.yml')
    end

    def self.load
      if File.exists?(database_yml)
        Blue.configure(:database => YAML::load(IO.read(database_yml))[Blue.env])
      end
    end
  end
end

Blue::DatabaseConfig.load

