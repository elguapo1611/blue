module Blue
  module Ntpd
    include Blue::Plugin

    def ntpd
      package :ntp, :ensure => :latest
      service :ntp, :ensure => :running, :require => package('ntp'), :pattern => 'ntpd'
    end

    setup do
      add_role(:ntpd)
      recipe :ntpd
    end
  end
end

