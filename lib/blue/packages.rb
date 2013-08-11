require 'blue/packages/manager'
require 'blue/packages/set'
require 'blue/packages/os'

module Blue
  module Packages
    include Blue::Plugin

    SETUP_LOCATION   = "/tmp/packages_setup.sh"
    INSTALL_LOCATION = "/tmp/install_packages.sh"

    included do
      package_manager.klasses << Blue::Packages::Os
    end

    def install_packages
      self.class.package_manager.packages.each do |pkg|
        package pkg, :ensure => :installed
      end
    end

    setup do
      recipe :install_packages
    end

    def self.push!
      Blue::Box.boxes.each do |box|
        box.package_manager.push_templates!
        box.package_manager.push_commands!
        box.package_manager.push_package_list!
      end
    end

  end
end

