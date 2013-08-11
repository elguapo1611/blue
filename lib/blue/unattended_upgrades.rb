module Blue
  module UnattendedUpgrades
    include Blue::Plugin

    def unattended_upgrades
      package 'unattended-upgrades',
        :ensure => :latest

      file "/etc/apt/apt.conf.d/20auto-upgrades",
        :ensure => :present,
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', '20auto-upgrades'), binding)
    end

    setup do
      recipe :unattended_upgrades
    end
  end
end

