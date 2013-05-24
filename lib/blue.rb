ENV['DEPLOY_ENV'] ||= 'production'

# require 'bundler/setup'
require 'capistrano'
require 'hashie'
require 'shadow_puppet'

require 'blue/version'
require 'blue/deep_merge'
require 'blue/config'

require 'blue/railtie' if defined?(Rails)

module Blue
  BLUE_CONFIG = 'config/blue.yml'

  include Blue::Config

  def self.env
    ENV['DEPLOY_ENV']
  end

  def self.rails_root
    @@rails_root ||= `pwd`.strip #File.join(current_release_dir.split('/')[0..3] + ['current'])
  end

  def self.rails_current
    @@rails_current ||= File.join(current_release_dir.split('/')[0..3] + ['current'])
  end

  def self.current_release_dir
    @@current_release_dir ||= `pwd`.strip
  end

  def self.shared_path
    @@shared_path ||= "/u/apps/#{Blue.config.application}/shared/"
  end

  @@boxes  = []
  def self.register_box(klass)
    @@boxes << klass
  end

  def self.boxes
    @@boxes
  end

  def self.load_boxes!
    Dir.glob("#{rails_root}/config/blue/boxes/#{env}/*.rb").each do |rb|
      require rb
    end
  end
end

if File.exists?(Blue::BLUE_CONFIG)
  require 'blue/config'
  require 'blue/database_config'
  require 'blue/gems'

  require 'capistrano/setup'
  require 'capistrano/deploy'
  require 'capistrano/rails'

  require 'blue/plugins'
  require 'blue/abstract_manifest'
  require 'blue/box'

  require 'capistrano/local_config'

  Blue.load_app_config!
  Blue.load_boxes!
end

require "capistrano/integration"

