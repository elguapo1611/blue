module Blue
  module Ntpd
    include Blue::Plugin

    def ntpd
      zone = 'UTC'

      package :ntp,
        :ensure => :latest

      service :ntp,
        :ensure  => :running,
        :require => package('ntp')

      file "/etc/timezone",
        :content => zone+"\n",
        :ensure => :present

      file "/etc/localtime",
        :ensure => "/usr/share/zoneinfo/#{zone}",
        :notify => service('ntp')
    end

    setup do
      add_role :ntpd
      recipe   :ntpd
    end
  end
end

