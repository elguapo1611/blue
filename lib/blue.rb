ENV['DEPLOY_ENV'] ||= 'production'

require 'bundler/setup'
require 'capistrano'
require 'hashie'
require 'shadow_puppet'

require 'blue/version'
require 'blue/deep_merge'

require 'blue/railtie' if defined?(Rails)

module Blue
  @@config = Hashie::Mash.new
  @@boxes  = []
  BLUE_CONFIG = 'config/blue.yml'

  def self.load_config!
    @@config.deep_merge!(YAML.load(IO.read(BLUE_CONFIG)))
  end

  def self.env
    ENV['DEPLOY_ENV']
  end

  def self.rails_root
    @@rails_root ||= `pwd`.strip #File.join(release_dir.split('/')[0..3] + ['current'])
  end

  def self.rails_current
    @@rails_current ||= File.join(release_dir.split('/')[0..3] + ['current'])
  end

  def self.release_dir
    @@release_dir ||= `pwd`.strip
  end

  def self.config
    @@config
  end

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

Blue.load_config!

require 'capistrano/setup'
#require 'capistrano/deploy'

require 'blue/plugins'
require 'blue/abstract_manifest'
require 'blue/box'

Blue.load_boxes!

require "capistrano/integration"

