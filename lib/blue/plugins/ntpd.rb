module Blue
  module Plugins
    module Ntpd

      def ntpd
        package :ntp, :ensure => :latest
        service :ntp, :ensure => :running, :require => package('ntp'), :pattern => 'ntpd'
      end

      def self.included(klass)
        klass.add_role(:ntpd)
        klass.class_eval do
          recipe :ntpd
        end
      end
    end
  end
end

