ENV['DEPLOY_ENV'] ||= 'production'

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

  def self.log_path
    @@log_path ||= shared_path + "log/"
  end

  def self.pids_path
    @@pids_path ||= shared_path + "pids/"
  end

  def self.gem_path
    @gem_path ||= Bundler.load.specs.detect{|s| s.name == 'blue' }.try(:full_gem_path)
  end
end

if File.exists?(Blue::BLUE_CONFIG)
  require 'blue/database_config'
  require 'blue/gems'

  require 'blue/plugins'
  require 'blue/abstract_manifest'
  require 'blue/box'
  require 'blue/initializer'

  Blue.load_app_config!
end

