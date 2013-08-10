require 'blue/iptables/rule'

module Blue
  module Iptables
    include Blue::Plugin

    def iptables
      package 'iptables',
        :ensure => :installed

      file '/etc/iptables.rules',
        :ensure   => :present,
        :mode     => 700,
        :owner    => 'root',
        :require  => package('iptables'),
        :content  => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'iptables.rules.erb'), binding)

      file '/etc/init/iptables.conf',
        :ensure   => :present,
        :mode     => 700,
        :owner    => 'root',
        :require  => file('/etc/iptables.rules'),
        :content  => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'iptables.init.erb'), binding)

      exec 'start iptables ; sleep 5',
        :refreshonly => true,
        :subscribe   => file('/etc/iptables.rules')
    end

    setup do
      recipe   :iptables
      add_role :iptables
    end
  end
end

