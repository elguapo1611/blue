module Blue
  module Packages
    extend ActiveSupport::Concern

    SETUP_LOCATION   = "/tmp/packages_setup.sh"
    INSTALL_LOCATION = "/tmp/install_packages.sh"

    module ClassMethods
      def included(klass)
        klass.package_klasses << self
      end
    end

    def self.push!
      Blue::Box.boxes.each do |box|
        box.push_templates!
        box.push_commands!
        box.push_package_list!
      end
    end
  end
end

