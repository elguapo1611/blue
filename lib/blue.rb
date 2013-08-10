ENV['DEPLOY_ENV'] ||= 'production'

require 'capistrano'
require 'hashie'
require 'shadow_puppet'
require 'active_support/core_ext'

require 'blue/version'
require 'blue/config'
require 'blue/plugin'

require 'blue/abstract_manifest'
require 'blue/config'
require 'blue/box'
require 'blue/packages'
require 'blue/packages/manager'
require 'blue/packages/os'

require 'blue/gems'
require 'blue/initializer'

require 'blue/railtie' if defined?(Rails)

module Blue
  include Blue::Config

  CONFIG = 'config/blue.yml'

  def self.env
    ENV['DEPLOY_ENV']
  end

  def self.single_host?
    Blue::Box.boxes.count == 1
  end

  def self.multi_host?
    !single_host?
  end

  configure(YAML.load(IO.read(CONFIG)).reverse_merge({
    :user  => 'blue',
    :group => 'blue',
    :scm   => 'git',
    :prod_safe_ip_addresses => [],
    :ruby  => {
      :major_version => '1.9.3',
      :minor_version => '448'
    },
    :networking => {
      :external_interface => 'eth0',
      :internal_interface => 'eth1'
    }
  }))
end

Blue::Box.load!

